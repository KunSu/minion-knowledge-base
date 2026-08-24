---
type: knowledge
title: 批量下载 Chase 对账单 PDF
description: 用已登录的 Chrome 会话 + chrome-devtools MCP 批量抓 Chase 对账单;核心是 documentId ≠ docKey 的三步链路
tags: [chase, browser-automation, chrome-devtools-mcp, personal-finance]
timestamp: 2026-08-24T00:00:00Z
---

# 批量下载 Chase 对账单 PDF

2026-08-14 实测跑通:一次性下载 3 个存款/信用卡账户 × 2022–2026 共 **167 份文件**,0 失败。其中 56 对后来证实是同一份合并对账单(见「陷阱:支票与储蓄是同一份合并对账单」),**去重后是 111 份不同的文档,仍覆盖 3 个账户**。

**实测范围**:支票、储蓄、信用卡三类产品。同一机构下未测到的产品(如车贷)按同样链路应当可行,但**没验证过**,别当成已验证事实。

## 前提:AI 能读到你已登录的浏览器

`chrome-devtools` MCP **连的是本机真实的 Chrome 实例**,不是另起的干净浏览器。所以已登录的 Chase 会话可以直接复用,不需要处理登录/MFA。

- `mcp__chrome-devtools__list_pages` 列出所有真实 tab → `select_page` 选中 → `evaluate_script` 在页内跑同源 JS(自动带 cookie)
- 能不能访问已开的银行 tab,**先调一次工具再答**。通用规则见 [Verification and Credential Discipline](../conventions/verification-discipline.md) §2「capability question」;本页实测:凭印象答「不行」是错的。
- 副作用:这是 Owner 正在用的浏览器,**页面状态会在脚本执行期间被人改动**(实测中途账户从储蓄跳到了信用卡)。每步动作前先确认当前 `pageTitle` / 年份,别假设状态没变。

## 核心:documentId ≠ docKey(踩坑最深的一处)

下载 **不是一个直链**,是三步。中间那步是把 `documentId` 换成一次性的 `docKey`(doc locator):

```
1) POST /svc/rr/documents/secure/idal/v2/docref/list
   body: accountFilter=<内部账户ID>&dateFilter.idalDateFilterType=<YEAR_FILTER>
   → { idaldocRefs: [ { documentId, documentDate:"YYYYMMDD", idaldocType:"STMT", pageCount } ] }

2) POST /svc/rr/documents/secure/idal/v2/dockey/list
   body: accountFilter=<同上>&dateFilter.idalDateFilterType=<同上>&documentId=<上一步的 documentId>
   → { docKey, docSOR:"STAR_MS", docURI:"/svc/rr/documents/secure/idal/v5/pdfdoc/star/list" }

3) GET <docURI>?docKey=<docKey>&sor=<docSOR>&adaVersion=false&download=true&csrftoken=<CSRF>
   → PDF 字节流
```

三个请求都要带 header `content-type: application/x-www-form-urlencoded; charset=UTF-8` 和 `x-jpmc-csrf-token: NONE`(POST 两步),以及 `credentials:'include'`。

**把第 1 步的 `documentId` 直接当 `docKey` 用会失败**,而且报错极具误导性:HTTP **504** + `DOCUMENT:DocumentRetrievalUnknownIssueCodeException` / `WS_NAME: "Invalid DocLocator"`。504 通常意味着网关超时,这里却在 ~160ms 就返回 —— **响应太快的 504 是伪装的业务错误,一定要读 response body**,否则会误判成限流而去加 sleep(实测浪费了几轮)。

## 年份筛选枚举

```
本年      CURRENT_YEAR
上一年    CURRENT_YEAR_MINUS_1
再往前    CURRENT_YEAR_MINUS_2 / _3 / _4 …
```

**实测验证到 `_4`(即本年 + 往前 4 年,共 5 个年份)。** UI 的「View:」下拉列出 8 个年份选项,按此推断上限是 `CURRENT_YEAR_MINUS_7`,但 `_5` 及更早**全部未实测**。

注意页面文案自述「7 years of statements」与 8 个下拉选项对不上(8 个选项跨 8 个年份)。两者矛盾,我没有实测哪个对 —— **要用到边界时自己试,不要引用本段当依据**。

不要试 `PRIOR_YEAR_1` 或显式 `dateFilter.dateLow/dateHigh` —— 前者 400,后者 500。

## 为什么不能直接点 UI 的下载按钮

页面原生下载是:建一个隐藏 `<form method=GET target="_self">` 然后提交 —— 即**整页导航**去取 PDF。所以:

- **连续点多行会互相取消**。实测点 7 行只落地 1 份(而且是中间那份,不是第一份)。
- 每次点击前还有一次异步请求去换 `docKey`,所以「点击 → 表单出现」有几百 ms 延迟,靠固定 `sleep` 拦截表单会漏(实测 160ms 只抓到 4/7)。

正确做法是绕开它:自己走三步链路 → `fetch` 拿 blob → 造 `<a download=文件名>` 点击。blob 下载**不触发导航**,可以稳定串行,167 份零失败。

> **注意:连续 blob 下载能跑通是域相关的,不要外推。** 本页这套在 Chase 域跑通了 167 份,但在未授予「自动多文件下载」权限的域上,**每次脚本执行只有第一个下载落地**。**换机器或换域先小批量试跑并核对落地数。** 原因、实测数据与 ZIP 打包解法见 [BoA 页](statement-acquisition-boa.md)陷阱 1。

## 可复用脚本骨架

在 `evaluate_script` 里跑(一次一个账户 × 2–3 个年份,避免单次调用超时):

```js
// ── 只需填这两个(都不是凭证)──────────────────
const ACCT_ID = '<accountFilter,见下节「账户内部 ID」>';
const LAST4   = '<该账户尾号四位,仅用于拼文件名>';
// ───────────────────────────────────────────────

const H = {'content-type':'application/x-www-form-urlencoded; charset=UTF-8','x-jpmc-csrf-token':'NONE'};
const sleep = ms => new Promise(r=>setTimeout(r,ms));

// csrftoken 在脚本内现场取,不要粘贴进来 —— 见 ../conventions/verification-discipline.md §4。
// 做法:拦住页面自己那次表单提交,读走 token 后把表单移除,不让它导航。
const CSRF = await (async () => {
  let tok = null;
  const origSubmit = HTMLFormElement.prototype.submit;
  const grab = f => { tok = f.querySelector('input[name=csrftoken]')?.value || tok; f.remove(); };
  HTMLFormElement.prototype.submit = function(){ grab(this); };          // 程序化提交
  const onSub = e => { e.preventDefault(); grab(e.target); };            // 点 submit 按钮
  document.addEventListener('submit', onSub, true);                      // 两条路都要堵
  document.querySelector('[id^="accountsTable-STATEMENTS-row0"][id$="requestThisDocumentAnchor-download"]')?.click();
  for (let i = 0; i < 30 && !tok; i++) await sleep(100);                 // 换 token 是异步的
  HTMLFormElement.prototype.submit = origSubmit;
  document.removeEventListener('submit', onSub, true);
  if (!tok) throw new Error('未取到 csrftoken —— 确认当前页有对账单行,且行号选择器仍匹配');
  return tok;
})();

for (const [yr, F] of [['本年','CURRENT_YEAR'],['上一年','CURRENT_YEAR_MINUS_1']]) {
  const r = await fetch('/svc/rr/documents/secure/idal/v2/docref/list', {method:'POST', credentials:'include', headers:H,
    body:`accountFilter=${ACCT_ID}&dateFilter.idalDateFilterType=${F}`});
  const refs = ((await r.json()).idaldocRefs||[]).filter(d=>d.idaldocType==='STMT');
  for (const d of refs) {
    const k = await (await fetch('/svc/rr/documents/secure/idal/v2/dockey/list', {method:'POST', credentials:'include', headers:H,
      body:`accountFilter=${ACCT_ID}&dateFilter.idalDateFilterType=${F}&documentId=${d.documentId}`})).json();
    if (!k.docKey) continue;
    const rr = await fetch(`${k.docURI}?docKey=${k.docKey}&sor=${k.docSOR}&adaVersion=false&download=true&csrftoken=${CSRF}`, {credentials:'include'});
    if (!rr.ok) continue;
    // 两道门都要。体积门槛只是「远低于最小真实对账单」的下限(实测约 94–330 KB),
    // 不是用来挡错误页的 —— 错误页大小不可预测(本域实测是几百字节的 JSON,
    // 但同类接口也见过几十 KB 的 HTML)。真正可靠的是 %PDF 头。
    const buf = new Uint8Array(await rr.arrayBuffer());
    if (buf.length < 20000) continue;
    if (buf[0]!==0x25 || buf[1]!==0x50 || buf[2]!==0x44 || buf[3]!==0x46) continue;   // '%PDF'
    const blob = new Blob([buf], {type:'application/pdf'});
    const bu = URL.createObjectURL(blob);
    const a = document.createElement('a');
    // 这是 Chase 站点自己的命名;若要并入某个归档,改用该归档的命名规范
    a.href = bu; a.download = `${d.documentDate}-statements-${LAST4}-.pdf`;
    document.body.appendChild(a); a.click();
    await sleep(180); a.remove(); URL.revokeObjectURL(bu);
  }
}
```

**关于 `csrftoken`**:它是会话级的,**不在 cookie 里**,所以只能从页面自己那次表单提交里截。上面骨架已经内联了这一步,**不要改成手填** —— 把 token 粘进脚本就等于把 live credential 写进了会被记录的地方(见 [Verification and Credential Discipline](../conventions/verification-discipline.md) §4「live credential」)。

截取要堵两条提交路径:程序化的 `HTMLFormElement.prototype.submit`,以及点 submit 按钮触发的 `submit` 事件(capture 阶段 + `preventDefault()`)。只堵一条会漏。

**DOM 选择器**(需要点 UI 时):
- 下载锚点 `#accountsTable-STATEMENTS-row{N}-cell3-requestThisDocumentAnchor-download`
- 左侧账户切换 `#bottom-<内部账户ID>`
- 年份下拉 `#header-filterstyledselect-0`,选项 `#container-{i}-filterstyledselect-0`(i=0 是最新一年)
- 页面用 `mds-*` web component,但对账单表格在 light DOM 里,普通 `querySelector` 就够

## 账户内部 ID(accountFilter)

这是 Chase 内部标识,不是账号;没有已认证会话单独拿它没用。**每次现场读取,不要写进任何提交的文件**:

- 左侧账户导航的锚点 id 就是 `bottom-<内部账户ID>`,遍历它们即可拿到全部账户的 ID 与显示名
- 或从对账单页 URL 的 `accountId=` 参数读当前账户的 ID

**已观察到的结算日规律**(与具体账户解耦):支票与储蓄同日,每月 8–11 日浮动;信用卡固定每月 4 日。**借记卡/ATM 卡没有对账单**,只有 ATM 收据(`docType=ATM_RECEIPTS`),别把它算成缺失。

## 陷阱:支票与储蓄是同一份合并对账单

Chase 对这两个产品出的是**一份** "Checking & Savings" 合并对账单,**两个账户 ID 请求下来的是同一个文件**。字节不同(PDF 里嵌了生成时间戳),但 `pdftotext` 提取的正文**逐字相同** —— 实测同期 56 对全部相同,零例外。

两个后果,方向相反,都要处理:

1. **下载侧**:按账户逐个下会拿到两套内容相同的文件。去重前**必须逐对验证正文相同**(比对提取文本,不是比对字节 —— 字节永远不同),不要因为体积相近就假定重复。
2. **解析侧**:去重后剩下的那一份**同时覆盖两个账户**。因此**文件数 ≠ 账户数,不能靠文件名尾号判定这份文件属于哪个账户** —— 必须读文档内部的分区(正文里有 `Checking & Savings` 汇总表,以及两个产品各自的明细区块),一份文档产出两条账户记录。否则被合并掉的那个账户会整个消失。

改文件名解决不了这件事,反而更隐蔽:名字只提一个产品,而内容含两个。

## 收尾:一定要对账,别靠数量猜

两个检查,**都要做**:

1. **月份连续性(首选,不需要会话)** —— 在该账户自己的首末区间内逐月走一遍找断月。当年年份天然不满 12(8 月时通常 7–8 份),开户月之前本就没有,**只有区间内的空洞才是真缺失**。
2. **与官方清单 diff(更强,需要会话)** —— 用第 1 步 `docref/list` 返回的 `documentDate` 列表当真相来源,逐个比对本地文件。它能抓到「整段尾部缺失」这种月份连续性看不出的问题。

有会话时用 2 复核 1;没有会话(如离线整理归档)时至少做 1。

同时校验有效性:文件头 `%PDF-` + size ≥ 20KB(下载失败常表现为几 KB 的错误页,而不是 0 字节)。

**不要相信脚本自己的成功计数器** —— 它统计的是「请求成功 + 触发点击」,不是文件落地。收尾必须回到文件系统。通用规则见 [Verification and Credential Discipline](../conventions/verification-discipline.md) §3「in-process counter」。

## 归档卫生

blob 下载遇到重名会被 Chrome 自动加 ` (1)` 后缀。清理前先按时间戳确认哪些是本次产生的,**不要误删 Owner 原有文件**。

## 相关

- [批量下载 Bank of America 对账单 PDF](statement-acquisition-boa.md) —— 同类任务但机制不同(两步链路、无 docKey)。**去 BoA 前务必先读它的「四个陷阱」**:Chrome 未授权域每次执行只放行 1 个下载、服务端认年份上下文、折叠面板名按账户类型变化、脚本自报成功≠文件落地。

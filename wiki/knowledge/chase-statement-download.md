---
type: knowledge
title: 批量下载 Chase 对账单 PDF
description: 用已登录的 Chrome 会话 + chrome-devtools MCP 批量抓 Chase 对账单;核心是 documentId ≠ docKey 的三步链路
tags: [chase, browser-automation, chrome-devtools-mcp, personal-finance]
timestamp: 2026-08-14T07:10:00Z
---

# 批量下载 Chase 对账单 PDF

2026-08-14 实测跑通:一次性下载 3 个账户 × 2022–2026 共 167 份对账单,0 失败。方法适用于任何 Chase 账户(储蓄/支票/信用卡通用)。

## 前提:AI 能读到你已登录的浏览器

`chrome-devtools` MCP **连的是本机真实的 Chrome 实例**,不是另起的干净浏览器。所以已登录的 Chase 会话可以直接复用,不需要处理登录/MFA。

- `mcp__chrome-devtools__list_pages` 列出所有真实 tab → `select_page` 选中 → `evaluate_script` 在页内跑同源 JS(自动带 cookie)
- **教训**:第一次被问「能不能访问我开着的 Chase tab」时我未验证就回答「不行」,是错的。**这类能力问题先调一次工具再答。**
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

**把第 1 步的 `documentId` 直接当 `docKey` 用会失败**,而且报错极具误导性:HTTP **504** + `DOCUMENT:DocumentRetrievalUnknownIssueCodeException` / `WS_NAME: "Invalid DocLocator"`。504 通常意味着网关超时,这里却在 ~160ms 就返回 —— **响应太快的 504 是伪装的业务错误,一定要读 response body**,否则会误判成限流而去加 sleep(我就浪费了几轮)。

## 年份筛选枚举

```
2026(本年) CURRENT_YEAR
2025        CURRENT_YEAR_MINUS_1
2024        CURRENT_YEAR_MINUS_2
2023        CURRENT_YEAR_MINUS_3
2022        CURRENT_YEAR_MINUS_4
```

UI 上「View:」下拉最多回溯 7 年(`CURRENT_YEAR_MINUS_6`)。不要试 `PRIOR_YEAR_1` 或显式 `dateFilter.dateLow/dateHigh` —— 前者 400,后者 500。

## 为什么不能直接点 UI 的下载按钮

页面原生下载是:建一个隐藏 `<form method=GET target="_self">` 然后提交 —— 即**整页导航**去取 PDF。所以:

- **连续点多行会互相取消**。实测点 7 行只落地 1 份(而且是中间那份,不是第一份)。
- 每次点击前还有一次异步请求去换 `docKey`,所以「点击 → 表单出现」有几百 ms 延迟,靠固定 `sleep` 拦截表单会漏(实测 160ms 只抓到 4/7)。

正确做法是绕开它:自己走三步链路 → `fetch` 拿 blob → 造 `<a download=文件名>` 点击。blob 下载**不触发导航**,可以稳定串行,167 份零失败。

## 可复用脚本骨架

在 `evaluate_script` 里跑(一次一个账户 × 2–3 个年份,避免单次调用超时):

```js
const CSRF = '<从页面表单里抓,见下>';
const H = {'content-type':'application/x-www-form-urlencoded; charset=UTF-8','x-jpmc-csrf-token':'NONE'};
const sleep = ms => new Promise(r=>setTimeout(r,ms));

for (const [yr, F] of [['2026','CURRENT_YEAR'],['2025','CURRENT_YEAR_MINUS_1']]) {
  const r = await fetch('/svc/rr/documents/secure/idal/v2/docref/list', {method:'POST', credentials:'include', headers:H,
    body:`accountFilter=${ACCT_ID}&dateFilter.idalDateFilterType=${F}`});
  const refs = ((await r.json()).idaldocRefs||[]).filter(d=>d.idaldocType==='STMT');
  for (const d of refs) {
    const k = await (await fetch('/svc/rr/documents/secure/idal/v2/dockey/list', {method:'POST', credentials:'include', headers:H,
      body:`accountFilter=${ACCT_ID}&dateFilter.idalDateFilterType=${F}&documentId=${d.documentId}`})).json();
    const rr = await fetch(`${k.docURI}?docKey=${k.docKey}&sor=${k.docSOR}&adaVersion=false&download=true&csrftoken=${CSRF}`, {credentials:'include'});
    const blob = await rr.blob();
    if (!rr.ok || blob.size < 2000) continue;              // 失败常表现为几 KB 的 JSON 错误页
    const bu = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = bu; a.download = `${d.documentDate}-statements-${LAST4}-.pdf`;  // 沿用 Chase 原命名
    document.body.appendChild(a); a.click();
    await sleep(180); a.remove(); URL.revokeObjectURL(bu);
  }
}
```

**拿 `csrftoken`**:它是会话级的,不在 cookie 里。最省事的办法是拦一次页面自己的下载 —— patch `HTMLFormElement.prototype.submit` 成「读走 input 里的 `csrftoken` 然后 `this.remove()` 不提交」,再点任意一行的下载图标。同时加一个 capture 阶段的 `submit` 监听 + `preventDefault()`(两条提交路径都要堵)。

**DOM 选择器**(需要点 UI 时):
- 下载锚点 `#accountsTable-STATEMENTS-row{N}-cell3-requestThisDocumentAnchor-download`
- 左侧账户切换 `#bottom-<内部账户ID>`
- 年份下拉 `#header-filterstyledselect-0`,选项 `#container-{i}-filterstyledselect-0`(i=0 是最新一年)
- 页面用 `mds-*` web component,但对账单表格在 light DOM 里,普通 `querySelector` 就够

## 账户内部 ID(accountFilter)

这是 Chase 内部标识,不是账号;没有已认证会话单独拿它没用。从左侧导航 `#bottom-<id>` 或 URL 的 `accountId=` 读到。

| 账户 | 内部 ID | 对账单日 |
|---|---|---|
| TOTAL CHECKING (...9229) | 699538464 | 每月 8–11 日浮动 |
| CHASE SAVINGS (...8220) | 699538475 | 每月 8–11 日浮动(与 9229 同日) |
| DEBIT/ATM CARD (...2595) | 699538483 | 无对账单(只有 ATM 收据) |
| FREEDOM UNLIMITED (...6299) | 693577487 | 固定每月 4 日 |
| CHASE AUTO LEASE (...0784) | 1178067352 | 未测 |

## 收尾:一定要对账,别靠数量猜

下完用**第 1 步的官方清单**当真相来源逐个 diff 本地文件,而不是「12 份就算齐」。当年年份天然不满 12(2026 年 8 月时:9229/8220 有 8 份到 Aug,6299 有 7 份到 Jul)。

同时校验有效性:`file` 认得是 PDF + 文件头 `%PDF-` + size ≥ 20KB(下载失败常表现为几 KB 的错误页,而不是 0 字节)。

## 相关

- 别把中途产生的重复/错名文件留在 `~/Downloads`:blob 下载重名会被 Chrome 加 ` (1)` 后缀,清理前先确认哪些是本次产生的(按时间戳),不要误删 Owner 原有文件。

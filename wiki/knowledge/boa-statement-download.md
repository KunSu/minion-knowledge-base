---
type: knowledge
title: 批量下载 Bank of America 对账单 PDF
description: BoA 三步链路与四个陷阱(Chrome 每次执行只放行 1 个下载 / 服务端认年份上下文 / 面板名按账户类型变化 / 脚本自报成功不等于文件落地)
tags: [bankofamerica, browser-automation, chrome-devtools-mcp, personal-finance]
timestamp: 2026-08-14T08:05:00Z
---

# 批量下载 Bank of America 对账单 PDF

2026-08-14 实测跑通:4 个 BoA 账户共 104 份(4921 存款 27、4109 信用卡 26、1277 房贷 51)。与 [Chase 那套](chase-statement-download.md) 机制完全不同,坑更多。

前提同 Chase:`chrome-devtools` MCP 连本机真实 Chrome,复用已登录会话。

## 拿到每个账户的入口(adx)

BoA 的每个账户有独立的 `adx` token,对账单页 URL 是:

```
https://secure.bankofamerica.com/mycomm-acc-stmts-docs/?adx=<adx>&request_locale=en-us
```

`adx` 从 accounts overview 页抓 —— 账户链接的 href 里就有:

```
https://secure.bankofamerica.com/myaccounts/brain/redirect.go?target=accountsoverview&request_locale=en-us
→ a[href*="target=acctDetails"] 的 href 里的 adx 参数
→ 或 #AccountItemQuickView_adx_<adx> 这个 id
```

## 下载链路(两步,比 Chase 少一步)

```
1) 从 DOM 读 documentId —— 每份对账单的卡片容器上有 data-docid="<20+ 位数字>"
   (同一个属性也叫 key;DISPFLD001 之类的值是区块容器,要用 /^\d{20,}$/ 过滤掉)

2) GET /ogateway/dsviewdocuments/omni/statements/v1/docViewDownload
      ?adx=<adx>&documentId=<docid>&adaDocumentFlag=N&menuFlag=download&request_locale=en-US
   → PDF 字节流
```

页面原生下载走 `window.open(该 URL)`。不需要像 Chase 那样换一次性 locator。

## 四个陷阱(全部实测踩过)

### 1. Chrome 每次脚本执行只放行 1 个下载

BoA 域没被授予「自动多文件下载」权限,**一次 `evaluate_script` 里连续触发 N 个下载,只有第一个落地,其余静默丢弃**。blob 下载和 `window.open` 导航下载都一样。(Chase 域能连下 167 个是因为 Owner 以前手动下过、权限已授予 —— 所以这个坑只在没授权的域上出现,不要以为 Chase 能跑通就都能跑通。)

**解法:在页内 fetch 全部 PDF → 手写 store-only ZIP → 只触发 1 次下载。** 然后 `unzip` 到目标目录。一次 20–24 份、约 4–9 MB 都没问题。ZIP 写法见下。

不要试图用 curl 带 cookie 绕过 —— 那需要把实时会话凭证(SSOTOKEN / SMSESSION / ah_token)落盘,**会被权限层拦下,而且拦得对**。凭证必须全程留在浏览器会话里。

### 2. 服务端认「页面当前选中的年份」

`docViewDownload` 不是无状态的。如果年份下拉停在 2024,那么 2025/2026 的 documentId **一律返回 76100 字节的 HTML 而非 PDF**(HTTP 200,不报错)。

**解法:必须「先把下拉切到该年份 → 再 fetch 该年份的 documentId」**。不能先把所有年份的 id 收集好再统一下载。

### 3. 折叠面板的名字按账户类型变化

往年数据默认折叠,要先点开 `button.panel-header`。但标题文字不一致:

| 账户类型 | 面板标题 |
|---|---|
| 存款 / 信用卡 | `Statements` |
| 房贷 | `Statements and Escrow Analysis` |

用 `/^Statements$/` 精确匹配会让房贷账户**除当年外全部返回 0 份**,看起来完全像「BoA 没有这些数据」。改成前缀匹配 `/^Statements/i` 后立刻拿到 51 份。

**推论(重要):任何「0 份」结果都要去读面板里的实际文字**,确认是 BoA 自己说 `You have no statements available` 还是自己的选择器没点开。把自己的 bug 当成数据缺失报给 Owner 是最坏的失败模式。

### 4. 脚本自报成功 ≠ 文件落地

第一版脚本里 `ok++` 统计的是「fetch 成功 + 触发了 `a.click()`」,于是报告 25 份成功,**实际磁盘上只有 1 份**(就是陷阱 1)。

**收尾必须用文件系统/官方清单对账,不能信脚本自己的计数器。** 校验三件事:`%PDF-` 文件头、体积下限(失败常是几十 KB 的 HTML 错误页,不是 0 字节)、以及月份连续性(见下)。

## 在线可用范围(2026-08 实测,各账户差异很大)

| 账户 | 可用范围 | 份数 |
|---|---|---|
| Adv Plus Banking …4921(存款) | 2024-06 起 | 27 |
| BOA Credit Card …4109 | 2024-07 起 | 26 |
| Mortgage …1277 | **2022-06 起** | 51 |

房贷的线上保留期明显比存款/信用卡长。更早的要走页面上的 **Request Statements**(线上补档,通常有手续费或需邮寄)—— 脚本做不到。

## 可复用脚本骨架

`evaluate_script` 里跑,一次 2–3 个年份(避免单次调用超时):

```js
const adx = new URLSearchParams(location.search).get('adx');
const sel = document.getElementById('yearDropDown');
const locals=[], central=[]; let offset=0;

for (const yr of ['2026','2025']) {
  sel.value = yr; sel.dispatchEvent(new Event('change',{bubbles:true}));
  await sleep(3200);
  // 展开折叠面板(前缀匹配!)
  for (let i=0;i<12;i++){
    const btn=[...document.querySelectorAll('button.panel-header')]
      .find(b=>/^Statements/i.test((b.textContent||'').trim()));
    if (btn && btn.getAttribute('aria-expanded')==='false'){ btn.click(); await sleep(1400); }
    if ([...document.querySelectorAll('[data-docid]')]
         .some(e=>/^\d{20,}$/.test(e.getAttribute('data-docid')||''))) break;
    await sleep(700);
  }
  // 收 (date, docid);日期从卡片正文 "Aug 11, 2026" 解析
  // 然后 fetch 每份,校验 %PDF-,塞进 ZIP 缓冲
}
// 最后:组 ZIP -> 一次 a[download].click()
```

**store-only ZIP(无压缩)要点**:CRC32 表 + 每份的 local file header(`PK\x03\x04`)+ 文件名 + 原始字节;最后 central directory(`PK\x01\x02`,每份记 offset)+ EOCD(`PK\x05\x06`)。`method=0`、compsize==uncompsize。DOS 时间/日期用固定常量即可。约 60 行,不需要外部库。

## 归属(owner)不能从对账单姓名栏推断

我曾用「PDF 正文姓名栏只有 KUN SU」判定信用卡 …4109 是个人账户,**这是错的** —— Owner 指出它也是 joint。**信用卡对账单表头只列 primary cardholder,不反映账户共有关系。**

存款/房贷对账单会并列两人(如 `KUN SU` / `YIMIN FU`),这种情况下可以判 joint;但**只出现一个名字不能反推为个人账户**。拿不准就问 Owner,别默默填一个。

## 收尾核对:月份连续性

比数量更可靠的检查是**在每个账户自己的首末区间内逐月走一遍,找断月**。当年年份天然不满 12(2026-08 时到 Jul/Aug),而账户开户月之前本就没有 —— 只有区间内的空洞才是真缺失。

实测 271 份(含 Chase)零断月、零无效文件。

## 相关

- [批量下载 Chase 对账单 PDF](chase-statement-download.md) —— Chase 是三步链路(`documentId` 要换一次性 `docKey`)、UI 用整页导航下载,与 BoA 的坑不同

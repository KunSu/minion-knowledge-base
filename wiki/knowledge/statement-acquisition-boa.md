---
type: knowledge
title: 批量下载 Bank of America 对账单 PDF
description: BoA 两步链路与四个陷阱(Chrome 每次执行只放行 1 个下载 / 服务端认年份上下文 / 面板名按账户类型变化 / 脚本自报成功不等于文件落地)
tags: [bankofamerica, browser-automation, chrome-devtools-mcp, personal-finance]
timestamp: 2026-08-14T09:30:00Z
---

# 批量下载 Bank of America 对账单 PDF

2026-08-14 实测跑通:4 个 BoA 账户共 104 份(存款 27、信用卡 26、房贷 51)。与 [Chase 那套](statement-acquisition-chase.md) 机制完全不同,坑更多。

前提同 Chase:`chrome-devtools` MCP 连本机真实 Chrome,复用已登录会话。

## 拿到每个账户的入口(adx)

BoA 的每个账户有独立的 `adx` token,对账单页 URL 是:

```
https://secure.bankofamerica.com/mycomm-acc-stmts-docs/?adx=<adx>&request_locale=en-us
```

`adx` **每次现场读取,不要写进任何提交的文件**。从 accounts overview 页抓 —— 账户链接的 href 里就有:

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

**日期从卡片正文解析**:卡片 innerText 里有 `Aug 11, 2026` 形式的结算日,用 `/([A-Z][a-z]{2}) (\d{2}), (\d{4})/` 取,月份缩写映射到两位数字。**同一日期可能出现在两个卡片**(「Most Recent」区与「Statements」区各一份),要按日期去重。

## 年份枚举

年份是个真 `<select id="yearDropDown">`,选项直接从 DOM 读,不用猜:

```js
const years = Array.from(document.getElementById('yearDropDown').options).map(o => o.value);
// 实测返回 8 个:本年往前共 8 个年份
```

切换方式:`sel.value = '2025'; sel.dispatchEvent(new Event('change', {bubbles:true}))`,然后等页面重渲染(见陷阱 2、3)。

## 四个陷阱(全部实测踩过)

### 1. Chrome 每次脚本执行只放行 1 个下载

BoA 域没被授予「自动多文件下载」权限,**一次 `evaluate_script` 里连续触发 N 个下载,只有第一个落地,其余静默丢弃**。blob 下载和 `window.open` 导航下载都一样。

> Chase 域能连下 167 个,**推断**是此前手动下载过、权限已授予 —— 但**没有查证** `chrome://settings/content/automaticDownloads`,这只是推断而非已验证事实。结论只取「不同域行为不同,必须小批量试跑并核对落地数」。

**解法:在页内 fetch 全部 PDF → 手写 store-only ZIP → 只触发 1 次下载。** 然后 `unzip` 到目标目录。一次 20–24 份、约 4–9 MB 都没问题。完整代码见下节。

不要试图用 curl 带 cookie 绕过 —— 那需要把实时会话凭证(`SSOTOKEN` / `SMSESSION` / `ah_token` 一类)落盘,**会被权限层拦下,而且拦得对**。凭证必须全程留在浏览器会话里。

### 2. 服务端认「页面当前选中的年份」

`docViewDownload` 不是无状态的。如果年份下拉停在某一年,**其他年份的 documentId 一律返回约 76 KB 的 HTML 而非 PDF**(HTTP 200,不报错)。

**解法:必须「先把下拉切到该年份 → 再 fetch 该年份的 documentId」**。不能先把所有年份的 id 收集好再统一下载 —— 这是实测踩过的坑:先收集全部 id 再下载,只有最后停留那一年的成功。

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

**收尾必须用文件系统/官方清单对账,不能信脚本自己的计数器。**

## 完整脚本:抓一批年份 → 打包 → 单次下载

在 `evaluate_script` 里跑。一次放 2–3 个年份(约 20–24 份),避免单次调用超时。

```js
const sleep = ms => new Promise(r => setTimeout(r, ms));
const MON = {Jan:'01',Feb:'02',Mar:'03',Apr:'04',May:'05',Jun:'06',
             Jul:'07',Aug:'08',Sep:'09',Oct:'10',Nov:'11',Dec:'12'};
const adx = new URLSearchParams(location.search).get('adx');
const YEARS = ['2026','2025'];          // 本批要抓的年份
const PREFIX = 'stmt';                  // 输出文件名前缀,自己定

// ── store-only ZIP 写入器(无压缩,不依赖外部库)──────────────
const CRC = (() => { const t = new Uint32Array(256);
  for (let n=0;n<256;n++){ let c=n; for(let k=0;k<8;k++) c = (c&1)?(0xEDB88320^(c>>>1)):(c>>>1); t[n]=c>>>0; }
  return t; })();
const crc32 = u8 => { let c = 0xFFFFFFFF;
  for (let i=0;i<u8.length;i++) c = CRC[(c ^ u8[i]) & 0xFF] ^ (c>>>8);
  return (c ^ 0xFFFFFFFF) >>> 0; };
const u16 = v => [v & 255, (v>>8) & 255];
const u32 = v => [v & 255, (v>>8) & 255, (v>>16) & 255, (v>>24) & 255];
const enc = new TextEncoder();
const DT = 0x5A00, DD = 0x5D0E;         // 固定 DOS 时间/日期(内容不依赖它)
const locals = [], central = [];
let offset = 0;

const addToZip = (name, data) => {
  const nb = enc.encode(name), crc = crc32(data), sz = data.length;
  locals.push(new Uint8Array([0x50,0x4b,3,4, ...u16(20), ...u16(0), ...u16(0),
    ...u16(DT), ...u16(DD), ...u32(crc), ...u32(sz), ...u32(sz), ...u16(nb.length), ...u16(0)]));
  locals.push(nb); locals.push(data);
  central.push(new Uint8Array([0x50,0x4b,1,2, ...u16(20), ...u16(20), ...u16(0), ...u16(0),
    ...u16(DT), ...u16(DD), ...u32(crc), ...u32(sz), ...u32(sz), ...u16(nb.length),
    ...u16(0), ...u16(0), ...u16(0), ...u16(0), ...u32(0), ...u32(offset)]));
  central.push(nb);
  offset += 30 + nb.length + sz;
};
const buildZip = () => {
  const cdSize = central.reduce((a,b) => a + b.length, 0);
  const eocd = new Uint8Array([0x50,0x4b,5,6, ...u16(0), ...u16(0),
    ...u16(central.length/2), ...u16(central.length/2), ...u32(cdSize), ...u32(offset), ...u16(0)]);
  return new Blob([...locals, ...central, eocd], {type:'application/zip'});
};
// ───────────────────────────────────────────────────────────

const sel = document.getElementById('yearDropDown');
const log = [];

for (const yr of YEARS) {
  // 陷阱 2:必须先切到本年份,再抓本年份的文档
  sel.value = yr;
  sel.dispatchEvent(new Event('change', {bubbles:true}));
  await sleep(3200);

  // 陷阱 3:前缀匹配,不是 /^Statements$/
  for (let i=0; i<12; i++) {
    const btn = Array.from(document.querySelectorAll('button.panel-header'))
      .find(b => /^Statements/i.test((b.textContent||'').trim()));
    if (btn && btn.getAttribute('aria-expanded') === 'false') { btn.click(); await sleep(1400); }
    if (Array.from(document.querySelectorAll('[data-docid]'))
          .some(e => /^\d{20,}$/.test(e.getAttribute('data-docid')||''))) break;
    await sleep(700);
  }

  // 收 (date, docid),按日期去重
  const seen = new Set(), items = [];
  for (const c of document.querySelectorAll('[data-docid]')) {
    const id = c.getAttribute('data-docid');
    if (!id || !/^\d{20,}$/.test(id)) continue;
    const m = (c.innerText||'').match(/([A-Z][a-z]{2}) (\d{2}), (\d{4})/);
    if (!m) continue;
    const date = `${m[3]}-${MON[m[1]]}-${m[2]}`;
    if (!date.startsWith(yr) || seen.has(date)) continue;
    seen.add(date); items.push({date, id});
  }
  if (!items.length) {                    // 陷阱 3 的自检:读面板文字再判断
    const btn = Array.from(document.querySelectorAll('button.panel-header'))
      .find(b => /^Statements/i.test((b.textContent||'').trim()));
    log.push(`${yr}: 0 份 — 面板文字: ${(btn?.closest('div')?.innerText||'').slice(0,80)}`);
    continue;
  }

  for (const it of items) {
    const u = `/ogateway/dsviewdocuments/omni/statements/v1/docViewDownload`
            + `?adx=${adx}&documentId=${it.id}&adaDocumentFlag=N&menuFlag=download&request_locale=en-US`;
    const r = await fetch(u, {credentials:'include'});
    if (!r.ok) { log.push(`${it.date} HTTP${r.status}`); continue; }
    const data = new Uint8Array(await r.arrayBuffer());
    // 陷阱 2 的自检:非 PDF 说明年份上下文不对
    if (data.length < 8000 || data[0]!==0x25 || data[1]!==0x50 || data[2]!==0x44 || data[3]!==0x46) {
      log.push(`${it.date} NOT_PDF ${data.length}(很可能是年份上下文不对)`); continue;
    }
    addToZip(`${PREFIX}_${it.date}.pdf`, data);
    log.push(`${it.date} ok ${data.length}`);
  }
}

// 陷阱 1:全部打进一个 ZIP,只触发这一次下载
const blob = buildZip();
const bu = URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = bu; a.download = 'boa_statements.zip'; a.style.display = 'none';
document.body.appendChild(a); a.click();
await sleep(1800); a.remove(); URL.revokeObjectURL(bu);

return {files: central.length/2, zipBytes: blob.size, log};
```

落地后解包(目标目录自己定,下面用归档目录举例):

```bash
cd ~/Downloads && unzip -o -q boa_statements.zip -d <目标目录>
rm boa_statements.zip
```

**`central.length/2` 就是打进包的文件数** —— 每份文档往 `central` 推两个元素(header + 文件名)。用它和 `log` 里的 `ok` 行数交叉核对,再回到文件系统数一遍(陷阱 4)。

## 在线可用范围(2026-08 实测,各账户类型差异很大)

| 账户类型 | 可用范围 | 份数 |
|---|---|---|
| 存款(checking) | 约 2 年 | 27 |
| 信用卡 | 约 2 年 | 26 |
| **房贷** | **约 4 年** | 51 |

**房贷的线上保留期明显比存款/信用卡长。** 更早的要走页面上的 **Request Statements**(线上补档,通常有手续费或需邮寄)—— 脚本做不到,需 Owner 决定。

判定「某年真的没有」要看面板文字 `You have no statements available. If you need an older statement, visit Request Statements in Online Banking.`,而不是看自己拿到 0 份(陷阱 3)。

## 归属(owner)不能从对账单姓名栏推断

存款与房贷对账单会**并列两位持有人**,而**信用卡对账单只列 primary cardholder**。所以:

- 并列两人 → 可判为共有
- **只出现一个名字 → 不能反推为个人账户**

实测踩过:据此把一张共有信用卡误判为个人账户,由 Owner 纠正。**归属以 Owner 确认为准,拿不准就问,别默默填一个。**

## 收尾核对:月份连续性

比数量更可靠的检查是**在每个账户自己的首末区间内逐月走一遍,找断月**。当年年份天然不满 12,而账户开户月之前本就没有 —— **只有区间内的空洞才是真缺失**。

有会话时再用页面的年份清单复核一遍(与 [Chase 页](statement-acquisition-chase.md)「收尾」一节同构:官方清单是更强的真相来源,月份连续性是不需要会话的廉价检查)。

同时校验有效性:文件头 `%PDF-` + 体积下限(失败常是几十 KB 的 HTML 错误页,不是 0 字节)。

## 相关

- [批量下载 Chase 对账单 PDF](statement-acquisition-chase.md) —— Chase 是三步链路(`documentId` 要换一次性 `docKey`)、UI 用整页导航下载,与 BoA 的坑不同

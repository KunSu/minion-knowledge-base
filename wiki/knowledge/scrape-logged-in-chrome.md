---
type: knowledge
title: 连已登录 Chrome 抓取网站(含小红书反爬)的可复用方法
description: Claude Code 稳定连接带登录态的 Google Chrome、抓取需登录内容的完整方法链，含小红书(rednote)反爬的踩坑与对策。为"自主 web 抓取 agent"沉淀的核心技术。
tags: [scraping, puppeteer, chrome, rednote, agent, anti-bot]
timestamp: 2026-07-13T00:00:00Z
---

# 连已登录 Chrome 抓取网站的可复用方法

> 首次实践：2026-07-13 抓取小红书 openclaw 收藏夹。对应 idea「build 一个自主 web 抓取 agent」(已入 minion-brain inbox)。

## 核心结论：怎么稳定连上带登录态的 Chrome

**不要**用官方默认路径开 `--remote-debugging-port`：Chrome 136+ 禁止在**默认 profile** 上开调试端口（这就是直接加 `--chrome` 之类连不上登录态的根因）。

**两条可行路径**：

1. **官方 chrome-devtools MCP + autoConnect（Chrome 144+）**：
   ```
   claude mcp add -s user chrome-devtools -- npx -y chrome-devtools-mcp@latest --autoConnect=true
   ```
   需在 `chrome://inspect/#remote-debugging` 开启远程调试并在浏览器点 Allow。**限制**：MCP 工具在会话启动时注入，`mcp add` 后必须**重开会话**才可用。

2. **复制 profile + puppeteer-core（本次实际用的，不需重开会话，全自动）**：
   - 复制 Default profile 的登录态文件（`Cookies`、`Network/Cookies`、`Login Data`、`Local State`、`Preferences`）到临时 dir；
   - 用临时 dir + 调试端口启动 Chrome（独立 profile 可开调试端口，cookie 登录态随之带过去）：
     ```
     "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
       --remote-debugging-port=9333 --user-data-dir=/tmp/xxx-profile about:blank &
     ```
   - `puppeteer-core`（装在项目外，`npm i puppeteer-core`，不下载自带浏览器）`connect({browserURL:'http://127.0.0.1:9333'})` 驱动。
   - **先探哪个 profile 有登录态**：读各 profile 的 `Cookies` sqlite，`SELECT count(*) ... WHERE host_key LIKE '%目标域名%'`，命中最多的就是登录 profile（本次 Default 有 32 个 rednote cookie）。

## 提数据：优先内部状态，不要死磕 DOM

- 小红书是**虚拟列表**：DOM 只渲染可见的 ~5 个卡片，滚动会 recycle，靠 DOM 收集链接最多拿到 ~84/91，且拿不全。
- **金矿是 `window.__INITIAL_STATE__`**：
  - board 笔记全量在 `__INITIAL_STATE__.board.boardFeedsMap[boardId].notes`（每条含 `noteId`/`displayTitle`/`xsecToken`/`cover`），并有 `hasMore` 标志判断是否加载完。
  - profile 首屏笔记在 `__INITIAL_STATE__.user.notes`（嵌套数组）。
- note 详情 URL 格式：`/board/{boardId}/{noteId}?xsec_token=...&xsec_source=pc_board`（**xsec_token 必需**，否则打不开详情）。
- 触发懒加载：viewport 要**小**（否则整页一屏装下、`scrollHeight==innerHeight`，IntersectionObserver 永不触发）；用真实滚轮事件 `page.mouse.wheel({deltaY})`，纯 `window.scrollTo` 常无效。

## 反爬 / 限流（关键教训）

- **裸调用签名 API 会被 406**：小红书分页 API 需要 JS 生成的 `x-s`/`x-t` 签名头，`fetch` 裸调用被拦。
- **抓太快触发风控**：连续快速打开详情页会撞到 **"Security Verification"** 验证页——抓到的是验证页而非笔记正文。本次 84 条里 28 条中招。
- **对策**：
  - 详情页之间加**足够间隔**（首次 0.7s 太快；重抓时用 3.5s+ 间隔、每页停 6.5s）；
  - 被限流时**不要硬刚重试**，标记为 `pending`、等限流窗口过去再增量补抓；
  - **增量 checklist**：每条记 `status`(scraped/pending_rate_limited/missing) + `ingested` 标志，支持断点续抓、避免重复。
- **数据源天然缺口**：board 标称 91 条，`hasMore:false` 时 feed 只返回 84 条——差的 7 条是**已删除/失效的收藏**，不是抓取 bug。

## 复用清单（下次抓小红书直接照做）

1. 探 profile 找登录态 → 2. 复制 profile 起调试 Chrome → 3. puppeteer connect → 4. 目标页读 `__INITIAL_STATE__` 拿全量链接 → 5. 逐条详情**带足够延迟** → 6. 检测 "Security Verification" 标记 pending → 7. 增量 checklist 记账 → 8. 按 [kb-ingest](../../skills/kb-ingest/SKILL.md) 落盘。

相关：本次抓取的成果见 [wiki/knowledge/rednote/](rednote/)（81 条笔记各自独立成页）。

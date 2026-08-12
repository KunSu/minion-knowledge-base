---
type: raw
id: 698379ea000000002202d407
title: "OpenClaw 2.2更新，支持QMD这个隐藏玩法太"
description: "小红书 openclaw 收藏夹笔记原文:OpenClaw 2.2更新，支持QMD这个隐藏玩法太"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/698379ea000000002202d407?xsec_token=ABV29qeL_bYUIaU3bm76GP0n39ozCc9a_TPjhvdXBdCk0=&xsec_source=pc_board
tags: [rednote, openclaw]
timestamp: 2026-07-13T00:00:00Z
---

# OpenClaw 2.2更新，支持QMD这个隐藏玩法太

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/698379ea000000002202d407?xsec_token=ABV29qeL_bYUIaU3bm76GP0n39ozCc9a_TPjhvdXBdCk0=&xsec_source=pc_board
- **作者**: DeepJerry
- **日期**: Edited at Feb 5

## 正文

刚刚更新了 OpenClaw (原 Clawdbot) 2.2 ，琢磨了一下新出的 QMD 后端，发现了一个超级无敌的“神仙玩法”！🔥 这就把我的私藏配置分享给大家，直接让你的 AI Agent 智商原地起飞！🚀
	
👇 我的独家“外挂大脑”配置思路
我们都知道这次更新支持了 QMD 作为记忆后端 ，但只用来存聊天记录太浪费了！我试着给 Agent 挂载了一个“实时更新的本地图书馆”，效果炸裂！🤯
	
1️⃣ 第一步：给 AI 喂“真理之书” (Ingest) 📚 我写了一个简单的脚本（挂在 Cron 定时任务里），每天自动把这些东西抓取到本地：
OpenClaw 官方文档
Clawdhub 文档
openclaw/skills 整个仓库的代码
	
2️⃣ 第二步：构建“大脑索引” (Build Collection) 🧠 用 QMD 工具 (github.com/tobi/qmd) 把上面下载的一堆 Markdown 和代码文件建成一个 Collection。这一步是为了让 AI 能毫秒级检索到最新的技术细节。
	
3️⃣ 第三步：见证魔法 (Show Time) ✨ 配置好之后，我发现可以直接对 Agent 下这种离谱的指令：
✅ 指令一：“云执行”技能（这个最绝！）
“请查看技能库里的 Y 技能，阅读它的代码，然后假装我们已经安装了它，直接执行！” 👉 结果：Agent 真的去读了那个技能的源码，然后完美模拟了运行结果！我根本不需要真的去 install 那个技能，省了好多事！😭
	
✅ 指令二：智能查错
“用 QMD 查阅最新的官方文档，对比我的 config.yaml，看看我有哪里配置错了？给我出一份优化报告。” 👉 结果：再也不用担心配置项改名或者过期了，AI 比我更懂文档！
	
✅ 指令三：避免重复造轮子
“我想写个功能 X，你帮我查查现在的 Skills 仓库里，是不是已经有人写过了？”
💡 个人心得： 这个玩法本质上是把 RAG (检索增强生成) 用到了极致。以前我们是“喂饭”给 AI，现在是教 AI “自己去翻说明书”。 强力推荐大家试试这个思路，OpenClaw 2.2 真的越来越像一个成熟的贾维斯了！🤖✨

## 图片(3)

- https://sns-web-i10.rednotecdn.com/202607131555/ef2a806f663697e432ab6e0e0afba085/spectrum/1040g0k031s62prgf58105obt9vs0jcm2q3h8ie8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131555/a11b919d8e7ae902db57f216bb4b6c9a/spectrum/1040g0k031s62prgf58005obt9vs0jcm2jn0bk9g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131555/7253c0a761afe27be14a4ce1ede27d67/spectrum/1040g0k031s62prgf580g5obt9vs0jcm2ubd9bug!nd_dft_wlteh_webp_3?src=A

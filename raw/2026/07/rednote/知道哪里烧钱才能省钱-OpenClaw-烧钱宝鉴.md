---
type: raw
id: 69985e6b0000000015030ef8
title: "知道哪里烧钱才能省钱🦞OpenClaw 烧钱宝鉴"
description: "小红书 openclaw 收藏夹笔记原文:知道哪里烧钱才能省钱🦞OpenClaw 烧钱宝鉴"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69985e6b0000000015030ef8?xsec_token=ABaMOxo-HVEXoL4KW6b7c7iNxXxtv9Yn_J8wQZ6ulXPKQ=&xsec_source=pc_board
tags: [rednote, openclaw]
timestamp: 2026-07-13T00:00:00Z
---

# 知道哪里烧钱才能省钱🦞OpenClaw 烧钱宝鉴

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/69985e6b0000000015030ef8?xsec_token=ABaMOxo-HVEXoL4KW6b7c7iNxXxtv9Yn_J8wQZ6ulXPKQ=&xsec_source=pc_board
- **作者**: 趴在关键词上捡钱
- **日期**: Edited at Feb 20

## 正文

零基础直接上手OpenClaw，2 周开荒终于搞明白钱烧在哪儿了。
	
 踩过的坑
 用免费模型省钱
我试过。Google Cloud 300刀免费额度。结果频繁触发429限速，最终被400锁区送走。期间网关直接崩。配置一直不稳定，两周时间全卡在维稳阶段，根本没法往前推。
	
 用本地模型兜底
受限于Mac 24GB 内存，本地只能跑 14B 参数量的小模型。跟云端大模型差距太大，推理拉胯、废话多、执行不果断。更坑的是，切换模型时上下文压力反而变大——小模型生成的冗长内容全部堆进历史记录，下一轮调用更贵的模型时，这些上下文一起被重新发送。
	
X上一位工程师的How to Reduce OpenClaw Model Costs by up to 90%给出了系统方案：
	
 先明确5大烧钱机制
 上下文无限膨胀：历史+工具返回全部累积，30轮后200K+ tokens，回一句ok等于重发一部小说
	
 System Prompt重复注入：SOUL.md等人设文件(8K-14K tokens)每次API调用全量发送，你还没开口已烧上万token
	
 工具输出堆积：文件列表、浏览器快照、命令返回值全部写入历史，每次后续调用重新传输
	
 心跳空转：默认30分钟一次Heartbeat，即使回复OK也携带全量上下文。用Opus=$108/月
	
 Cron定时叠加：每个任务创建独立会话+全量注入，15分钟间隔=96次/天，Opus上$10-20/天
	
 再给出可操作方法
✅ Heartbeat调到55分钟，匹配Anthropic缓存TTL，命中后成本降90%
✅ 智能路由：日常走Haiku($0.25/MTok)，复杂推理才用Opus
✅ ClawRouter（11天2.4k⭐）：本地分析复杂度，自动分配模型，最高省95%
✅ Prompt缓存：静态部分只付一次全价，后续90%折扣
✅ 本地模型分流：Qwen 32B零边际成本
	
 但有一个盲区
这些方案解决不了子代理Session Spawn上下文回滚撑爆Context的问题。Pilot Protocol可以解决：让子代理独立保存对话，通过通信协议交互，避免主代理读取全部子代理上下文。不过它很复杂，我还在消化中。
	
近期X也流行挖掘苹果自带的 LaunchAgent 等工具替代 Corn 定时任务。下期分享。

## 图片(8)

- https://sns-web-i10.rednotecdn.com/202607131557/3d896dda7eeae163895e13ae5a3214cf/notes_pre_post/1040g3k831sqfo51s5s105p97n43aml93rrh67kg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/95fa300efde6942c2b87506e98b576f5/notes_pre_post/1040g3k031sqeqvj6ls505p97n43aml93tjiqrvg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/0c73750784a5aa406bf03be232d6f439/notes_pre_post/1040g3k031sqeqvj6ls5g5p97n43aml935citiig!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/2077ad38d8df64db43cf23bdd00e4457/notes_pre_post/1040g3k031sqeqvj6ls605p97n43aml937q9d5go!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/2b182da0ce53892ce278bf94b6de763d/notes_pre_post/1040g3k031sqeqvj6ls6g5p97n43aml93337saig!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/8998d5d16e0889635db33be60a6f5ca1/notes_pre_post/1040g3k831sqfo51s5s005p97n43aml93ddgi49o!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/0937d522359b3ca52103e9ac789fd355/notes_pre_post/1040g3k831sqfo51s5s0g5p97n43aml9305k26sg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131557/0fe94dd4f208d4a202331ed9f7e943f8/notes_pre_post/1040g3k831sqfo51s5s1g5p97n43aml93p4euj78!nd_dft_wlteh_webp_3?src=A

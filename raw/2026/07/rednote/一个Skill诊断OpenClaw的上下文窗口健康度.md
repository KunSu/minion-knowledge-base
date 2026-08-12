---
type: raw
id: 69ae37f7000000002603f671
title: "一个Skill诊断OpenClaw的上下文窗口健康度"
description: "小红书 openclaw 收藏夹笔记原文:一个Skill诊断OpenClaw的上下文窗口健康度"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69ae37f7000000002603f671?xsec_token=ABU27Hn32axJ5z4PJfL9Tc5gF4bRe6-wJTNEndIXrHPJQ=&xsec_source=pc_board
tags: [rednote, openclaw, openclaw, 程序员, agent, 智能体, context]
timestamp: 2026-07-13T00:00:00Z
---

# 一个Skill诊断OpenClaw的上下文窗口健康度

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/69ae37f7000000002603f671?xsec_token=ABU27Hn32axJ5z4PJfL9Tc5gF4bRe6-wJTNEndIXrHPJQ=&xsec_source=pc_board
- **作者**: 北屿Yorick
- **日期**: Mar 8
- **标签**: #openclaw #程序员 #agent #智能体 #context

## 正文

你的Token到底消耗在了哪里，一个Skill查看OpenClaw的上下文占用，生成详细报表。
	
使用方式很简单，告诉小龙虾安装这个技能 clawhub install context-doctor，然后让他运行后发把图片发过来。
	
要看懂这张图，我们需要了解每次对话除了我们提出的问题还发送了什么，或者说到底什么在占用上下文：
	
1. 每次对话一定会发送：
- 系统提示词
- 工作区文件（SOUL.md, USER.md, IDENTITY.md, HEARTBEAT.md, MEMORY.md 等）
- 工具 schemas
- 技能元数据描述（用于技能路由），不加载完整 SKILL.md 内容
	
2. 可能会发送：
- 对话历史（轮数越多占用越大）
- 动态加载的技能完整内容（需要时才加载）
- 调用工具后的返回结果（可能很大）
	
优化建议：
- 工作区文件保持精简（尤其是 MEMORY.md）
- 长对话可以 /new 或 /reset 新建会话清空历史
- 大文件用记忆索引（MEMORY.md 只存索引，详细内容放 memory/*.md）
	
#openclaw #程序员 #agent #智能体 #context

## 图片(2)

- https://sns-web-i10.rednotecdn.com/202607131553/33778ff51f2ae66807fde9b7c4a08853/spectrum/1040g34o31tfqk6vi58105nqsq1i08vguf1qemdg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131553/0d155c67f1cd0f2b64f092a424afd0ef/notes_pre_post/1040g3k031tfqpnmklm005nqsq1i08vgutbt1lu8!nd_dft_wlteh_webp_3?src=A

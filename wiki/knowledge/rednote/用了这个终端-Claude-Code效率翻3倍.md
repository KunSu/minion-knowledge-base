---
type: knowledge
id: 69d7f0bf000000001a02ed6c
title: "用了这个终端，Claude Code效率翻3倍"
description: "小红书 openclaw 收藏笔记精编:用了这个终端，Claude Code效率翻3倍"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69d7f0bf000000001a02ed6c?xsec_token=ABxbUT1YdFZoLy_v5zYysEhJaCnOdx59mtSEADmDKKgY0=&xsec_source=pc_board
tags: [rednote, openclaw, AI编程, ClaudeCode, cmux终端, AI开发效率, VibeCoding, Claude并行开发, 终端工具, macOS开发]
timestamp: 2026-07-13T00:00:00Z
---

# 用了这个终端，Claude Code效率翻3倍

> 来源:小红书 openclaw 收藏夹 · 作者 AI 实验室 · Apr 9
> 原文存档:[用了这个终端-Claude-Code效率翻3倍.md](../../../raw/2026/07/rednote/用了这个终端-Claude-Code效率翻3倍.md)

## 要点

cmux 是目前用 Claude Code 做并行开发的最优解。

用 Claude Code 最大的痛点就是一次只能跑一个任务。写前端的时候后端只能干等着，跑测试的时候改 bug 也得排队。tmux 能解决一部分问题，但通知全靠 macOS 的「Claude is waiting for your input」——开了 8 个窗格根本分不清哪个在等你。

cmux 解决了这个问题。基于 Ghostty 的 macOS 原生终端，Manaflow（YC）两人团队做的，GitHub 13K+ Star，Mitchell Hashimoto（Ghostty 创始人）亲自背书：「a huge success story for libghostty」。

核心三个能力：

1️⃣ 通知环 — Agent 等你时窗格亮蓝环，完成亮绿环，出错亮红环。Cmd+Shift+U 一键跳转最新未读。像 Slack 未读消息一样管理 Agent。

2️⃣ 垂直标签栏 — 每个 workspace 显示 git 分支、PR 状态、工作目录、端口和最新通知。一眼看清 5 个并行任务。

3️⃣ 内置浏览器 + Socket API — 终端旁边开 WebKit 浏览器，Agent 能操作页面元素。cmux send / read-screen / notify 全套 CLI，主 Agent 编排子 Agent 零开销。

上手极简：brew install 一行，读你现有 Ghostty 配置。cmux claude-teams 一条命令启动 teammate 模式，自动分屏。

但是，仅 macOS、不恢复活跃进程、Issue 1000+ 说明还在快速迭代。

并行跑 3 个以上 Agent → 必装。单任务开发 → Ghostty 够了。服务器 → 继续 tmux。

你们平时都用什么终端？评论区聊聊

## 标签

#AI编程 #ClaudeCode #cmux终端 #AI开发效率 #VibeCoding #Claude并行开发 #终端工具 #macOS开发 #AgentCoding #Ghostty #AI编程工具

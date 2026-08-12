---
type: knowledge
id: 6a45ec3c00000000170083a7
title: "最强教程：Fable最值的玩法！"
description: "小红书 openclaw 收藏笔记精编:最强教程：Fable最值的玩法！"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/6a45ec3c00000000170083a7?xsec_token=ABUmMig8KI57GgvRDIBJBAa3kjgqvpixJL_newEyhsJ8U=&xsec_source=pc_board
tags: [rednote, openclaw, ClaudeCode, Fable5, AIagent, 模型编排, 效率工程, 独立开发者, AI编程工作流]
timestamp: 2026-07-13T00:00:00Z
---

# 最强教程：Fable最值的玩法！

> 来源:小红书 openclaw 收藏夹 · 作者 宇宙幻想Oscar · Jul 1 中国香港
> 原文存档:[最强教程-Fable最值的玩法.md](../../../raw/2026/07/rednote/最强教程-Fable最值的玩法.md)

## 要点

Claude Code的/agents功能很多人没玩明白。Fable 5 reasoning拉满当orchestrator，Opus和Sonnet做子agent，再外挂Codex做peer review，四模型并行，Fable token消耗压到最低。

具体配置：

1. 主模型切到Fable 5，/model → Fable 5，reasoning effort设max。Fable只负责plan、decompose、synthesize，不碰具体实现。

2. 建两个子agent：

◦ deep-reasoner → 绑定Opus，prompt写明"reasoning-heavy phases only, return concise conclusion"

◦ fast-worker → 绑定Sonnet，prompt写明"mechanical tasks, boilerplate, tests, execute efficiently"

3. 装Codex插件：/plugin marketplace add openai/codex-plugin-cc，然后/codex:setup。Codex不是reviewer，是peer engineer。

4. CLAUDE.md里写死workflow：

◦ Fable = orchestrator

◦ Opus = 架构/复杂问题

◦ Sonnet = 体力活

◦ Codex = 独立视角，高stakes决策时和Opus并行跑，Fable综合两边结论

5. Prompt Fable时直接给goal + context + constraints，让它先出plan再delegate。Fable会自动把任务丢给对应agent。

效果：Fable token消耗降低约60%，复杂任务处理时间从20分钟压到5分钟。因为Fable只动脑子不动手，动手的是Sonnet和Opus，Codex负责兜底。

做复杂项目效果直接拉满起飞！

## 标签

#ClaudeCode #Fable5 #AIagent #模型编排 #效率工程 #独立开发者 #AI编程工作流

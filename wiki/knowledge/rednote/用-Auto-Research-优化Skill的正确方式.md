---
type: knowledge
id: 69c8942a000000001a02b398
title: "用 Auto Research 优化Skill的正确方式"
description: "小红书 openclaw 收藏笔记精编:用 Auto Research 优化Skill的正确方式"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69c8942a000000001a02b398?xsec_token=ABjWuHNX0zciy9ub4LsD-t62xrffc-FE3HZaGaeZJgWIw=&xsec_source=pc_board
tags: [rednote, openclaw, AISkill, AutoResearch, Evals, Karpathy, AI工具]
timestamp: 2026-07-13T00:00:00Z
---

# 用 Auto Research 优化Skill的正确方式

> 来源:小红书 openclaw 收藏夹 · 作者 奥森木 · Edited at Mar 28
> 原文存档:[用-Auto-Research-优化Skill的正确方式.md](../../../raw/2026/07/rednote/用-Auto-Research-优化Skill的正确方式.md)

## 要点

用 Karpathy 的 Auto Research 优化 AI Skill 的真实经历。三次踩坑，每次都以为找到了捷径，结果都翻车了。

第一次：直接把 Skill 丢给工具，让它自动生成测试和评判标准，跑了一夜。分数蹭蹭涨，但仔细一看——Skill 根本没变好。因为评判标准是机器编的，衡量的是错误的东西。

第二次：接入了 Hamel 的 evals-skills，输入质量确实提升了。但评判标准还是没改，自己也没看过一条输出。好的弹药 + 歪的瞄准镜 = 还是打偏。

第三次：老老实实学到"三个鸿沟"框架——理解鸿沟、规范鸿沟、泛化鸿沟。在跑任何自动化之前，先手动读输出、归纳失败模式、写评判标准、手动校准。然后才启动自动优化。这次终于有效了。

核心教训：你不能自动化跳过理解。总有人要先手动搞懂问题出在哪，那个人就是你。

这个道理不只适用于 AI，做产品也一样——没亲自看过用户反馈就上线功能，跟没看过输出就跑优化循环，本质上是同一个错误。

#AISkill #AutoResearch #Evals #Karpathy #AI工具 提示词优化 #产品方法论 #AI开发

## 标签

#AISkill #AutoResearch #Evals #Karpathy #AI工具

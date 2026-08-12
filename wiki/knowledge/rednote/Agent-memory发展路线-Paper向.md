---
type: knowledge
id: 69a74440000000001a02bfc2
title: "Agent memory发展路线（Paper向）"
description: "小红书 openclaw 收藏笔记精编:Agent memory发展路线（Paper向）"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69a74440000000001a02bfc2?xsec_token=ABgC05TlB4lvVFWZQ_quaz_32aA5rAv72eF86Fik2T8yI=&xsec_source=pc_board
tags: [rednote, openclaw, Agent, Memory, LLM, AI记忆]
timestamp: 2026-07-13T00:00:00Z
---

# Agent memory发展路线（Paper向）

> 来源:小红书 openclaw 收藏夹 · 作者 AgenSea · Mar 3
> 原文存档:[Agent-memory发展路线-Paper向.md](../../../raw/2026/07/rednote/Agent-memory发展路线-Paper向.md)

## 要点

Mem0  工程化 Memory 基建。通过维护动态 Memory Graph，实现跨对话实体整合与状态更新，强调生产级可落地性。

A-Mem (Agentic Memory) 动态语义网络式记忆组织。LLM 主动生成标签与语义链接，使记忆结构随时间演化。

Memory-R1 (Yan et al., 2025) 强化学习驱动的双智能体框架。通过显式记忆动作（ADD / UPDATE / DELETE / NOOP）与记忆蒸馏机制，实现可学习的记忆管理策略，在极小数据规模下显著提升长程推理能力。

MEM1 (2025) 内生状态式记忆模型。通过压缩循环状态替代追加式上下文堆叠，实现恒定内存占用的长程交互能力。

ReMemR1 (2025) 引入回溯机制与多级奖励信号，缓解递归状态压缩带来的信息不可逆丢失问题。

Mem-α (2026) 分层记忆架构（Core / Semantic / Episodic）与显式记忆操作策略优化，实现高度自治的记忆管理系统。

## 标签

#Agent #Memory #LLM #AI记忆

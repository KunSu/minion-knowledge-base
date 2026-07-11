---
type: convention
title: 多模型编排规范
description: Owner 的 subagent 分工与工作流链(源自 minion-brain/SUBAGENTS.md,已装入 ~/.claude 全局)
resource: https://www.developersdigest.tech/blog/fable-5-orchestrator-model-playbook
tags: [claude, subagents, orchestration]
timestamp: 2026-07-08T00:00:00Z
---

# 多模型编排规范

核心思路:贵模型只坐编排位(决策错误会向下游放大),便宜模型干活(错误局部、重试便宜)。

| 代理 | 模型 | 用途 |
|---|---|---|
| 主会话(编排) | Fable | 任务分解、派发、冲突裁决、最终综合 |
| deep-reasoner | Opus | 仅高价值决策:架构、复杂 bug、算法设计;分析阶段不改文件 |
| peer-review | Sonnet + Codex(外部) | 对已有决策/变更独立评审 + 提替代方案;Codex 不可用必须显式声明 |
| fast-worker | Sonnet | 机械任务:样板、测试、格式化、简单编辑 |
| verifier | Sonnet | 全新上下文验证:跑测试对照需求,只报告不修复 |

默认工作流链:deep-reasoner 定方案 →(重大变更)peer-review 二意见 → fast-worker 执行 → verifier 验证 → Fable 裁决。简单任务跳过前两步。

守则:异步派发不阻塞;失败才升级模型层级;fresh-context 验证优于自我批评;不让子代理"展示完整推理过程"。

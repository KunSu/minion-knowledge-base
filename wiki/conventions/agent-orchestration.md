---
type: convention
title: 多模型编排规范
description: Owner 的 subagent 分工与工作流链,适用于所有个人项目(已装入全局 Claude 配置)
scope: personal
resource: https://www.developersdigest.tech/blog/fable-5-orchestrator-model-playbook
tags: [claude, subagents, orchestration]
timestamp: 2026-07-08T00:00:00Z
---

# 多模型编排规范

> 原文:[raw/2026/07/subagents-orchestration.md](../../raw/2026/07/subagents-orchestration.md)(Owner 手订 SUBAGENTS.md)

核心思路:贵模型只坐编排位(决策错误会向下游放大),便宜模型干活(错误局部、重试便宜)。

| 代理 | 模型 | 用途 |
|---|---|---|
| 主会话(编排) | Fable | 任务分解、派发、冲突裁决、最终综合 |
| deep-reasoner | Opus | 仅高价值决策:架构、复杂 bug、算法设计;分析阶段不改文件 |
| peer-review | Sonnet + Codex(外部) | 对已有决策/变更独立评审 + 提替代方案;Codex 不可用必须显式声明 |
| fast-worker | Sonnet | 机械任务:样板、测试、格式化、简单编辑 |
| verifier | Sonnet | 全新上下文验证:跑测试对照需求,只报告不修复 |

默认工作流链:deep-reasoner 定方案 →(重大变更)peer-review 二意见 → fast-worker 执行 → verifier 验证 → Fable 裁决。简单任务跳过前两步;是否「重大」由编排者判断(涉及架构、数据模型、外部依赖、安全 → 重大)。

## 代理定义要点

- 代理文件在各项目 `.claude/agents/`(或全局 `~/.claude/agents/`,项目级同名覆盖全局)。
- 均不限制 `tools`(保留 shell/脚本能力),靠 prompt 约束行为(peer-review/verifier 不修改被审查的变更)。
- peer-review 跑在 Sonnet 上、经 Codex CLI 取第二意见(`codex` 不是合法 model 值);verifier 只返回 PASS/FAIL + 证据。

## Codex 安装(一次性)

```bash
npm install -g @openai/codex && codex login && codex exec "say ok"
```

Claude Code 内:`/plugin marketplace add openai/codex-plugin-cc` → `/codex:setup`

## 运行守则

- 优先异步派发子代理,不阻塞等最慢的 worker
- 全新上下文的 verifier 验证优于自我批评
- 失败才升级模型层级,不默认用贵模型
- 安全扫描类任务直接固定到 Opus(绕开 Fable 安全分类器的 refusal 重试延迟)
- 不让子代理「完整展示推理过程」(触发 reasoning_extraction 分类器)
- 共享前缀(约定文档、repo map)吃 prompt caching,worker 成本再降约一半

# Subagent 编排配置 (Fable 5 Orchestrator Setup)

参考: [The Fable 5 Orchestrator Playbook](https://www.developersdigest.tech/blog/fable-5-orchestrator-model-playbook)

核心思路:贵模型只坐编排位(决策会向下游放大),便宜模型干活(错误局部、重试便宜)。主会话跑 Fable 5 做编排,子代理按 frontmatter 里的 `model` 各自定价执行。

## 分层路由

| 层级 | 代理 | 模型 | 用途 |
| --- | --- | --- | --- |
| Orchestrator | 主会话 | Fable 5 | 任务分解、派发、冲突裁决、最终综合 |
| Reasoning | `deep-reasoner` | Opus | 重推理阶段:架构、复杂 bug、算法设计 |
| Peer Review | `peer-review` | Sonnet + Codex(外部) | 对已有决策/变更做独立评审 + 提出独立视角/替代方案(创始人/CTO 视角),双视角结论由 Fable 综合 |
| Workhorse | `fast-worker` | Sonnet | 机械任务:样板代码、测试、格式化、简单编辑 |
| Verifier | `verifier` | Sonnet | 全新上下文验证:跑测试/lint/build,对照需求检查 diff,只报告不修复 |

## 默认工作流链

```
deep-reasoner 定方案
  → (重大变更时) peer-review 出第二意见 + 替代方案
  → fast-worker 执行
  → verifier 全新上下文验证
  → Fable 综合裁决
```

简单任务跳过前两步:Fable 直接派 fast-worker,或自己回答。是否"重大"由 Fable 判断(涉及架构、数据模型、外部依赖、安全 → 重大)。

## 代理定义

文件位于 `.claude/agents/`:

- `deep-reasoner.md` — model: opus。仅用于高价值决策(架构、复杂 bug、算法设计),简单问题不触发以控成本。可执行 shell/脚本调查复现,但分析阶段不修改文件(落地归 fast-worker)。只返回编排者可执行的简洁结论。
- `fast-worker.md` — model: sonnet。高效执行,不越界,完成后 1-3 句汇报。
- `peer-review.md` — model: sonnet(注:`codex` 不是合法的 model 值;该代理运行在 Sonnet 上,通过 Codex 插件/CLI 调用 Codex 获取独立意见)。不止评审:也提出独立视角/替代方案。返回 Sonnet 视角 + Codex 视角 + 分歧点,不选边,最终建议由 Fable 给出。Codex 不可用时必须显式声明,禁止编造。
- `verifier.md` — model: sonnet。全新上下文验证完成的工作(fast-worker/deep-reasoner 产出、合并前的变更):跑测试/lint/build,对照原始需求检查,只返回 PASS/FAIL + 证据,不做修复。

所有 agent 均不限制 `tools`(保留 shell/脚本执行能力),通过 prompt 约束行为(如 peer-review/verifier 不修改被审查的变更)。

## Codex 安装(一次性)

CLI(终端执行):

```bash
npm install -g @openai/codex
codex login          # ChatGPT 账号或 API key 授权
codex exec "say ok"  # 冒烟测试
```

插件(Claude Code 中执行):

```
/plugin marketplace add openai/codex-plugin-cc
/codex:setup
```

## 上下文接入

本文件通过 `AGENTS.md` 中的 `@SUBAGENTS.md` 引用自动加载(CLAUDE.md → AGENTS.md → SUBAGENTS.md),编排守则对每次会话生效。

## 运行守则(摘自 playbook)

- 优先异步派发子代理,不要阻塞等待最慢的 worker。
- 用全新上下文的 verifier 子代理做验证,优于自我批评。
- 失败才升级模型层级,不要默认用贵模型。
- 安全扫描类任务直接固定到 Opus,绕开 Fable 的安全分类器,避免 refusal 重试延迟。
- 提示词里不要让子代理"完整展示推理过程",会触发 reasoning_extraction 分类器。
- 共享前缀(约定文档、repo map)利用 prompt caching,worker 成本可再降约一半。

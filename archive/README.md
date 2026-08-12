# Archive — 已停用的配置

> **不进 `index.md`,不参与检索。** 这里是停用但可能想回头看的配置原文。
> 与 `raw/`(外部原文存档)不同:`raw/` 是摄入源,这里是曾经生效过的自有配置。

## subagents/ — 四子代理编排(停用)

Fable 5 分层路由那套:主会话编排 + `deep-reasoner`/`peer-review`/`fast-worker`/`verifier` 四个子代理按 model 分级执行。

**停用原因**:开发以 [mattpocock skills](https://github.com/mattpocock/skills) 为主,那套 skill 自己规定子代理编排方式(如 `/code-review` 的 Standards+Spec 双轴并行、`/design-an-interface` 的 design-it-twice),两套编排规则叠加会产生歧义。停用自有编排,避免冲突。

**已于 2026-08-12 恢复**(本目录按软删除文化保留为历史)。现行版本在 `base/agents/`(Claude)与 `base/codex-agents/`(Codex),规范见 [wiki/conventions/agent-orchestration.md](../wiki/conventions/agent-orchestration.md)。

与 mattpocock skills 的冲突这样解掉:**只分发 agent 定义,不加 `@SUBAGENTS.md` 无条件引用**。subagent 定义是声明式的——放着不改变编排行为,只在 `description` 匹配时才派发,所以 skill 有自己编排时走 skill 的,没有时才落到这六个角色。当年的歧义正是无条件全局加载造成的。

## commands/ — 已弃用的斜杠命令

- **`code-review.md`** — 派 Sonnet 做对抗式审查(找 bug/安全/回归)。与 mattpocock 的 `code-review` skill **撞名**,已被后者遮蔽。统一使用 mattpocock 版本(Standards + Spec 双轴)。若想恢复,必须改名(如 `adversarial-review`)后放回 `base/commands/`。

# Archive — 已停用的配置

> **不进 `index.md`,不参与检索。** 这里是停用但可能想回头看的配置原文。
> 与 `raw/`(外部原文存档)不同:`raw/` 是摄入源,这里是曾经生效过的自有配置。

## subagents/ — 四子代理编排(停用)

Fable 5 分层路由那套:主会话编排 + `deep-reasoner`/`peer-review`/`fast-worker`/`verifier` 四个子代理按 model 分级执行。

**停用原因**:开发以 [mattpocock skills](https://github.com/mattpocock/skills) 为主,那套 skill 自己规定子代理编排方式(如 `/code-review` 的 Standards+Spec 双轴并行、`/design-an-interface` 的 design-it-twice),两套编排规则叠加会产生歧义。停用自有编排,避免冲突。

**恢复方法**:把 `SUBAGENTS.md` 与 `agents/*.md` 放回 `base/`,在 `base/CLAUDE.md` 末尾加一行 `@SUBAGENTS.md`,重跑 `scripts/init.sh`。恢复时需重新解决与 mattpocock skills 的编排优先级问题。

## commands/ — 已弃用的斜杠命令

- **`code-review.md`** — 派 Sonnet 做对抗式审查(找 bug/安全/回归)。与 mattpocock 的 `code-review` skill **撞名**,已被后者遮蔽。统一使用 mattpocock 版本(Standards + Spec 双轴)。若想恢复,必须改名(如 `adversarial-review`)后放回 `base/commands/`。

---
name: kb-lint
description: Health-check the knowledge base. Use when the owner says "lint my KB", "check the KB", or periodically after heavy ingest/remember activity.
---

# kb-lint — 健康检查

## 检查项

1. **断链**:wiki 页之间的 markdown 链接指向不存在的文件
2. **index 一致性**:wiki 页缺 index.md 条目;index 条目指向不存在的页;被 replaces 取代的页仍留在 index
3. **frontmatter 合法性**:缺 type/title/description/timestamp;type 枚举非法;timestamp 格式错误
4. **replaces 完整性**:replaces 指向不存在的页;replaces 成环(A 取代 B,B 取代 A)
5. **矛盾探测**:同主题页面间的表述冲突(尽力而为,列出可疑对)
6. **孤儿页**:没有任何入链且不在 index 的页
7. **raw 完整性**:raw 文件缺 resource 溯源;raw 被 wiki 之外引用
8. **孪生文件漂移**:`base/CLAUDE.md` 与 `base/AGENTS.md` 的共有小节内容不一致。二者是同一份偏好的两个 harness 入口,除「模型 / effort」「开发工作流」「Amazon 环境提示」(harness 特定)外,其余小节应逐字相同。报告出 diff 即可,不自动合并——哪边是权威由 Owner 定。
9. **编排配置一致性**(agents):
   - `~/.claude/agents/` 与 `~/.codex/agents/` 的 symlink 是否失效(指向已删除的源)
   - Claude agent 的 `model` 是否硬编码了具体 ID 而非别名(硬编码 → 代际升级会漏)
   - Codex agent 的 `model` ID 是否仍在当前模型目录内(**过期 ID 在 Codex 侧静默失败**,不报错)
   - `wiki/conventions/agent-orchestration.md` 的映射表与实际 agent 文件是否一致
   - **Luna 边界**:`model` 含 `luna` 的角色是否被赋予了编排/派发职责(违反 leaf-only,是能力边界不是风格偏好)
   - Claude agent 的 `model`/`effort` 是否被 `settings.json` 的 `availableModels` 白名单拦掉(被拦时 Claude Code 静默替换成继承模型,不报错)。查两件事:①用到的裸别名(`opus`/`sonnet`/`haiku`/`fable`)是否都在白名单;②各别名经 `ANTHROPIC_DEFAULT_*_MODEL` 解析出的全 ID 是否也在白名单
   - `ANTHROPIC_DEFAULT_*_MODEL` 是否给**原生 1M 的模型**(Sonnet 5 / Fable 5)错加了 `[1m]` 后缀——会产出白名单外的 ID 并静默降级
   - Codex 的 `[model_providers.amazon-bedrock.aws]` 是否显式设了 `profile`(缺失会退到 `~/.aws/credentials` 的 `[default]` 静态凭证 → 401,且 `mwinit` 救不了)

## 输出与修复

- **自动修复(无需确认)**:仅限 index.md 条目的增补/摘除
- **只报告**:其余全部列成清单(路径 + 问题 + 建议),由 Owner 决定;修复动作走 kb-remember 的规则(指令层照旧需确认)
- 结果追加到 log.md 一行:`日期 | lint | - | N 项问题`

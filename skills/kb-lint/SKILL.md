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
8. **孪生文件漂移**(两组,只报 diff 不自动合并——哪边权威由 Owner 定):
   - `base/CLAUDE.md` ↔ `base/AGENTS.md`:同一份偏好的两个 harness 入口。**只有标了 harness 特定的小节允许不同**(模型 / effort、Amazon 环境提示);「开发工作流」两侧都必须有「skill 自带编排时遵循 skill 自己的结构」这条,其余小节逐字相同
   - `base/agents/*.md` ↔ `base/codex-agents/*.toml`:六个角色的行为约束应等价(角色语义跨 harness 不变),差异只应出现在 model/effort 与 harness 机制上
9. **编排配置一致性**(agents)。判据与原理见 [wiki/conventions/agent-orchestration.md](../../wiki/conventions/agent-orchestration.md)——**该页是唯一正文,本项只列要查什么**:
   - `~/.claude/agents/` 与 `~/.codex/agents/` 的 symlink 是否失效
   - Claude agent 的 `model` 用别名而非硬编码 ID(见该页「代际适配方法」)
   - Codex agent 的 `model` ID 仍在当前模型目录内;与 `[agents]` 默认值重复的角色文件应删掉冗余键(同上节)
   - 该页映射表与实际 agent 文件一致
   - **Luna 边界**:用 `luna` 的角色未被赋予编排/派发职责(见该页「两条硬边界」)
   - 三个**静默失败**陷阱是否复现(见该页同名小节):白名单缺别名或缺解析后全 ID、原生 1M 模型误加 `[1m]`、Codex bedrock provider 缺 `profile`

## 输出与修复

- **自动修复(无需确认)**:仅限 index.md 条目的增补/摘除
- **只报告**:其余全部列成清单(路径 + 问题 + 建议),由 Owner 决定;修复动作走 kb-remember 的规则(指令层照旧需确认)
- 结果追加到 log.md 一行:`日期 | lint | - | N 项问题`

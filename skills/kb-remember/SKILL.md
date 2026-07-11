---
name: kb-remember
description: Persist a lesson, decision, or preference from the current conversation into the knowledge base. Use when the owner says "记住这个" / "remember this", or when a durable insight emerges (a debugging lesson, an architecture decision, a stated preference) worth saving proactively — propose it.
---

# kb-remember — 会话写回

## 流程

1. **提取**:从当前会话中提炼要沉淀的内容,写成简洁、自足的知识条目(脱离本会话也能读懂;含必要上下文与日期)。
2. **定位**:kb-query 式检索现有页 → 决定追加到现有页还是新建页;判断归属:
   - 偏好/工作方式 → `wiki/preferences/`(★指令层)
   - 规范/流程 → `wiki/conventions/`(★指令层)
   - 长期目标 → `wiki/goals/`(★指令层)
   - 项目决策/lesson → `wiki/projects/<project>.md`
   - 通用知识 → `wiki/knowledge/`
3. **写入**:
   - **指令层(★)**:先展示完整 diff(新页展示全文),Owner 确认后才写
   - 非指令层:直接写,但回复中说明写了什么、写到哪
4. **矛盾处理**:与现有页矛盾时当场问 Owner;新内容取代旧内容则在新页 frontmatter 标 `replaces: [旧页路径]` 并从 index.md 摘除旧页条目。
5. **收尾**:更新 `index.md` 受影响条目 + `log.md` 追加一行;git commit:`kb: remember <slug>`。

## 铁律

- 指令层未经确认不写
- 宁可问,不要静默覆盖或静默择一
- 条目必须自足:三个月后任何 AI 读到都能直接用

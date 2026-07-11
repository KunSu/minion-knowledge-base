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

## 输出与修复

- **自动修复(无需确认)**:仅限 index.md 条目的增补/摘除
- **只报告**:其余全部列成清单(路径 + 问题 + 建议),由 Owner 决定;修复动作走 kb-remember 的规则(指令层照旧需确认)
- 结果追加到 log.md 一行:`日期 | lint | - | N 项问题`

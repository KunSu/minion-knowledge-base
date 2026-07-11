---
name: kb-query
description: Answer questions from the knowledge base with citations. Use when the owner asks "what do I know about X", "what's in my KB about X", or when any task needs the owner's preferences, conventions, goals, or project context.
---

# kb-query — 检索问答

## 流程

1. **导航**:先读根 `index.md`,定位相关分区;需要时读子页。
2. **检索**:对 `wiki/` 做 grep(关键词 + 同义词);**不搜 `raw/`**(原料不是知识)。
3. **回答**:
   - 每个论点引用具体页面路径(如 `wiki/knowledge/nextjs.md`)
   - 页面有 `resource` 时可附原始来源
   - 被 `replaces` 取代的页不作为答案依据
4. **诚实边界**:KB 里没有就明说「KB 中没有相关记录」,不要用模型常识冒充 Owner 的知识;可以补充常识但必须区分「你的 KB 说」vs「一般而言」。
5. **发现矛盾**:两说都摆出来,指出矛盾,建议 Owner 用 kb-remember 裁决(标 replaces)。

## 铁律

- 无引用不成答案
- raw/ 永不进入检索与回答
- 只读操作:本 skill 不写任何文件

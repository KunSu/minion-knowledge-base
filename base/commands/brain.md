---
description: 从 minion-brain 拉出跨项目全局总览(待办/idea/进行中),不用打开浏览器
---

给我一份第二大脑 **minion-brain** 的跨项目全局总览。这是我最需要的"看到全局"的入口。

## 做法

1. 拉取当前所有活跃条目:

   ```bash
   cd "${MINION_BRAIN_DIR:-$HOME/Documents/Github/minion-brain}" && pnpm minion list
   ```

   若 `minion list` 只返回 AI 任务队列而非全部 items,则改用 export 读全量:
   ```bash
   cd "${MINION_BRAIN_DIR:-$HOME/Documents/Github/minion-brain}" && pnpm minion export --out /tmp/brain-snapshot.json && cat /tmp/brain-snapshot.json
   ```

2. 过滤掉 `archived` 和 `done`,把活跃条目**按 project 分组**呈现(无 project 的归到"未分类"):

   ```
   ## <项目名>
   - [status] [priority] title  (type)
   ```

   同一项目内按 priority(high→low)再按 status 排。

3. 末尾给一个**极简 standup**:
   - 🔴 高优先级但还在 Inbox 没启动的(容易漏的)
   - 🟡 卡在 Blocked / Pending Approval 的(需要我决策/推动的)
   - 💡 Inbox 里积压的 idea 数量(该清理/升级还是归档)

4. 如果 `$ARGUMENTS` 指定了某个项目或 type,只看那一部分。

5. **只读不改。** 全局偏好里说了动手前先问——这里只呈现,不替我改状态。

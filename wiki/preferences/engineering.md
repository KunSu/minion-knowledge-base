---
type: preference
title: 工程偏好
description: Owner 做产品与技术决策时的一贯倾向
tags: [engineering, architecture, mvp]
timestamp: 2026-07-08T00:00:00Z
---

# 工程偏好

- **MVP 极简主义**:keep everything minimized。先砍掉一切非必需基础设施(server、数据库、队列),能用「git repo + 文档规则」解决就不建系统;复杂设计留作未来蓝图存档。
- **文件即真相**:纯 Markdown + git 作唯一权威存储;一切索引/缓存必须可丢弃重建;拥抱开放标准(OKF)保证 10-20 年可迁移。
- **同步优于异步**:人在场时当场审核(如 ingest 当场过目),不留异步队列和积压。
- **指令层保护**:影响 AI 后续行为的内容(preferences/conventions/goals)改动必须先出 diff 经 Owner 确认;其余放手让 AI 自由写。
- **软删除文化**:不硬删数据;取代用 replaces 标记,历史靠 git 保留。
- **commit 纪律**:重要变更 commit 前先经 Owner 确认;不擅自 push。
- **手机场景**:是真实刚需,但优先用零建设方案(GitHub connector + skill 即文档)满足。

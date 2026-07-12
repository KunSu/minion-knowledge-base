---
type: preference
title: 工程偏好
description: Owner 做产品与技术决策时的一贯倾向,适用于所有项目
tags: [engineering, architecture, mvp, git]
timestamp: 2026-07-08T00:00:00Z
---

# 工程偏好

> 以下条目与任何具体项目无关,适用于 Owner 的所有工作。

- **MVP 极简主义**:keep everything minimized。先砍掉一切非必需的基础设施(服务端、数据库、队列、认证系统),能用「文件 + 版本控制 + 文档规则」解决的就不建系统;完整的复杂设计可以存档为未来蓝图,但不实现。
- **纯文本即真相**:权威数据优先用纯文本(如 Markdown)+ 版本控制存储;一切衍生数据(索引、缓存、数据库副本)必须可随时丢弃并从源重建;拥抱开放标准,保证 10-20 年可迁移、零厂商锁定。
- **同步优于异步**:Owner 在场时当场审核、当场决策;不设计异步审批队列,不留积压。
- **指令层保护**:任何会影响 AI 后续行为的内容(偏好、规范、目标、系统提示类配置),修改前必须先展示 diff,经 Owner 确认后才能写入。
- **版本控制纪律(硬性)**:commit 看本次改动的整体范围,`push` 永远是硬门——
  - 本次改动**只涉及**非指令层(projects / knowledge)→ 可 auto commit(视为预授权)。
  - 本次改动**触及**指令层(preferences / conventions / goals)或策略文件(PRD / README / AGENTS / CLAUDE / SKILL)→ 整批(含连带的 index / log / .gitignore)须 Owner 明说「可以 commit」后才 commit。一句话:**Owner 让 commit 才 commit,没让就不 commit。**
  - **push**:任何情况下**不得自行 push**,一律等 Owner 明确指示。
- **不可逆操作先确认**:涉及删除、覆盖、对外发送、以及其他难以撤销的操作,动手前先向 Owner 确认;一处 approve 不自动延伸到下一处。
- **软删除文化**:不硬删数据;内容被新版本取代时显式标记取代关系,历史靠版本控制保留。
- **跨设备/远程访问**:优先用零建设方案(现有平台的连接能力 + 规则即文档),不为单一场景自建服务。

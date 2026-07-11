# Minion Knowledge Base

> **任何 AI:读完本 README 你就知道怎么使用和维护这个 KB。这里是 Owner(Sunny)所有 AI 共享的唯一记忆源。**
> 格式:[OKF v0.1](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing) · 模式:[karpathy LLM wiki](https://github.com/Astro-Han/karpathy-llm-wiki)(raw→wiki 编译,综合发生在摄入时)

## 结构

```
raw/YYYY/MM/          外部原文存档。append-only,永不修改,不参与检索
wiki/preferences/     ★ Owner 的偏好(coding style、工作方式…)
wiki/conventions/     ★ 约定规范(TS 规范、git 流程…)
wiki/goals/           ★ 长期目标
wiki/projects/        项目上下文(架构决策、lessons learned)
wiki/knowledge/       通用知识页
index.md              全局目录 —— 查找先从这里进
log.md                操作日志 —— 每次写入追加一行
skills/               四个操作的完整规程(本 README 是摘要,细节以 skills 为准)
```

★ = **指令层**:影响 AI 之后的所有行为。**任何改动必须先向 Owner 展示 diff,确认后才能写入。**

## 四个操作

| 你要做什么 | 读哪个规程 | 一句话规则 |
|---|---|---|
| 摄入外部内容(URL/文件/文本) | `skills/kb-ingest/SKILL.md` | 编译成知识页草稿 → 标出与现有知识的冲突/不确定处 → **Owner 当场审核通过后**,raw+wiki+index+log 原子落盘;不通过则一个字节都不写 |
| 回答「我的 KB 里有什么」 | `skills/kb-query/SKILL.md` | 从 index.md 导航 + grep wiki/;**答案必须引用具体页面路径**;raw/ 不搜 |
| 沉淀会话中的 lesson/决策/偏好 | `skills/kb-remember/SKILL.md` | 写入对应 wiki 页(新建或追加);指令层先出 diff;与现有知识矛盾时当场问 Owner |
| 体检 | `skills/kb-lint/SKILL.md` | 断链/index 缺项/frontmatter 非法/replaces 环/矛盾;index 可自动修,其余只报告 |

## 页面格式(OKF frontmatter,每页必带)

```yaml
---
type: preference | convention | goal | project | knowledge | raw   # 必填
title: 页面标题
description: 一句话摘要
resource: https://...        # 来源溯源(没有则省略)
tags: [nextjs]
timestamp: 2026-07-08T10:00:00Z   # 最后更新时间
replaces: [wiki/knowledge/old.md] # 可选:本页取代旧页
---
```

正文用普通 Markdown;页面之间用相对路径链接(`[customers](../projects/minion-brain.md)`),链接构成知识图谱。

## 铁律(违反任何一条都是事故)

1. 指令层(preferences/conventions/goals)未经 Owner 确认不得写入。
2. raw/ 只增不改;进 wiki 的外部内容必须经过 Owner 当场审核。
3. 每次写入:更新受影响的 `index.md` 条目 + 在 `log.md` 追加一行(`日期 | 操作 | 路径 | 摘要`)。
4. 回答问题必须引用到页;KB 里没有就说没有,不编造。
5. 一页被 `replaces` 取代后:从 index.md 摘除,文件保留(git 即历史)。
6. 发现矛盾不要静默择一:ingest/remember 时当场问 Owner,query 时把两说都摆出来并指出矛盾。

## 没有 skill 加载能力的环境(手机 Claude / GPT / 任意 agent)

通过 GitHub connector/API 访问本 repo(private),先读本 README 和对应 `skills/*/SKILL.md`,然后照规程执行——skill 即文档,行为应与桌面端完全一致。

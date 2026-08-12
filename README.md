# Minion Knowledge Base

> **任何 AI:读完本 README 你就知道怎么使用和维护这个 KB。这里是 Owner(Kun)所有 AI 共享的唯一记忆源。**
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
AGENTS.md / CLAUDE.md agent 入口 —— progressive onboarding:只 load 核心纪律 + 「何时读什么」指针表,其余按需(非 wiki 页)
skills/               权威 skill 原文 —— kb-ingest/query/remember/lint + awake(本 README 是摘要,细节以 skills 为准)
.claude/skills/       桌面 Claude Code 的发现入口 —— 指向 ../../skills/<name> 的 symlink,单一权威、无拷贝
```

> **skills 两条路径、同一份文件**:桌面 Claude Code 从 `.claude/skills/` 自动加载(可 `/kb-ingest` 触发);手机/connector/无 harness 环境直接读 `skills/<name>/SKILL.md` 照做——行为一致。symlink 仅是桌面发现入口,web/connector 看的是 `skills/` 真文件,不依赖它。

★ = **指令层**:影响 AI 之后的所有行为。**任何改动必须先向 Owner 展示 diff,确认后才能写入。**

## 内容放哪层(分层判据)

写入前先判断内容属于哪层——目标是**常驻层尽量小**(每一行常驻规则都是 context 税,越多越稀释注意力、降低遵守度)。判据用两条正交的轴:**事实 vs 程序**、**普适 vs 局部**。

| 层 | 放什么 | 判据 | 加载方式 |
|---|---|---|---|
| **常驻**(AGENTS.md 核心纪律 + `preferences/`) | 跨所有任务的稳定倾向、不可违反的纪律、指针表 | 是**事实**、**每个任务**都要、**一句话**讲得清 | 无条件全量 |
| **`conventions/`** | 某"类工作"的多步规程 | 是**程序**(第一步…第二步…)、且只在**某类任务**才用 | `scope`/场景触发 |
| **`knowledge/`** | 事实、技法、领域知识 | 是**事实**,但**不是每次**都需要 | 指针表按需引用 |
| **`raw/`** | 外部原文存档 | append-only,只被 `knowledge/` 页引用 | 用时深挖 |

**口诀**:事实且普适 → 常驻;事实但局部 → knowledge 按需;程序且局部 → convention 触发;**一句话讲不完 → 拆成「指针 + 正文」**。

两条硬规则:
1. **一个事实一个 home**:同一事实只允许一份正文,可被指针/链接引用无限次。复述超过一句话就会 drift——改成链接(见 AGENTS.md「按需加载」指针表)。任务专属规则(如"抓网页时…")**绝不进常驻层**,放 `knowledge/`/`conventions/` 并在指针表用**场景触发词**引用。
2. **常驻文件宜精简**:AGENTS.md 走 progressive loading(核心纪律 + 指针表,正文按需),不预加载全部文档。

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
id: <源唯一标识>             # 可选:外部来源的唯一 ID(如小红书 noteId),用于机器寻址;文件名保持人可读,不放 ID
resource: https://...        # 来源溯源(没有则省略)
tags: [nextjs]
timestamp: 2026-07-08T10:00:00Z   # 最后更新时间
replaces: [wiki/knowledge/old.md] # 可选:本页取代旧页
scope: personal | amazon          # 可选(conventions 用):amazon=仅干 Amazon 活时才 load,个人项目不必读
---
```

正文用普通 Markdown;页面之间用相对路径链接(`[customers](../projects/minion-brain.md)`),链接构成知识图谱。

## 铁律(违反任何一条都是事故)

1. 指令层(preferences/conventions/goals)未经 Owner 确认不得写入。
2. raw/ 只增不改;进 wiki 的外部内容必须经过 Owner 当场审核。
3. 每次写入:更新受影响的 `index.md` 条目 + 在 `log.md` 追加一行(`日期 | 操作 | 路径 | 摘要`)。
   - **commit 看本次改动整体**:本次只动 `projects/`、`knowledge/` → auto commit;一旦触及指令层(preferences/conventions/goals)或策略文件(PRD/README/AGENTS/CLAUDE/SKILL),整批(含连带的 index/log/.gitignore)须 **Owner 明说「可以 commit」才 commit**。
   - **push 永不自行做**——任何情况下都等 Owner 明确指示。
   - 手机端(GitHub connector):write == commit,写即提交;指令层/策略文件在获 Owner commit 指示前不写。
4. 回答问题必须引用到页;KB 里没有就说没有,不编造。
5. 一页被 `replaces` 取代后:从 index.md 摘除,文件保留(git 即历史)。
6. 发现矛盾不要静默择一:ingest/remember 时当场问 Owner,query 时把两说都摆出来并指出矛盾。

## 没有 skill 加载能力的环境(手机 Claude / GPT / 任意 agent)

通过 GitHub connector/API 访问本 repo(private),先读本 README 和对应 `skills/*/SKILL.md`,照规程执行——skill 即文档,行为应与桌面端完全一致。若你要编排多个子代理,再读 `wiki/conventions/agent-orchestration.md`。

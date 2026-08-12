---
type: project
title: minion-brain
description: 第二大脑的 Web App(Next.js + Supabase)—— Inbox/待办/AI 任务队列的产品实现,不是配置中枢
resource: https://minion-brain.vercel.app
tags: [nextjs, supabase, second-brain, app]
timestamp: 2026-08-03T00:00:00Z
---

# minion-brain

**是什么**:第二大脑的 **Web App**(Next.js + Supabase,部署在 Vercel)。提供 Inbox、跨项目待办/idea 总览、AI 任务队列,手机和桌面都能看。附带 `pnpm minion` CLI。

**不是什么**:**不是配置中枢,不是知识库**。全局配置和知识都归 [minion-knowledge-base](../../base/README.md) 管。

## 与 KB 的分工(2026-08-03 决策)

曾一度考虑把 minion-brain 当作"所有开发的统一 setup 源"(base 配置 + 跨 repo context 都放它)。**否决了。**

| | minion-knowledge-base | minion-brain |
|---|---|---|
| 角色 | 大脑:唯一真相源 + 全局配置分发 | 被管理的 app 之一 |
| 形态 | 纯文本 repo,无构建 | Next.js app,有 node_modules |
| 职责 | 知识、偏好、跨项目 context、`base/` → `~/.claude/` | Inbox / 待办 / AI 任务队列的**产品** |

**理由**:
1. KB 的 README 首句已自我定义为"Owner 所有 AI 共享的唯一记忆源",两个 repo 各建一套"唯一真相源"在定义上矛盾(当时 `~/.claude/SUBAGENTS.md` 与 KB 的 `wiki/conventions/agent-orchestration.md` 已经是同一内容的两份副本,漂移正在发生)。
2. 配置中枢应当**纯文本、跨环境可读**(手机 claude.ai 走 GitHub 集成能直接读 md)。把它塞进一个带构建产物的 app 里,是让工具承担了不该有的职责。
3. KB 已有成熟机制可复用:`index.md` 导航、`log.md` 记账、指令层保护铁律、`skills/` → `.claude/skills/` 的 symlink 分发。

## 它在这套体系里的位置

仍是 base 的一个**依赖**:全局命令 `/brain`(跨项目总览)和 `/idea`(捕获想法进 Inbox)调用它的 CLI。所以它是"随处可触发的 inbox 后端"。

- 路径:默认 `$HOME/Documents/Github/minion-brain`,可用环境变量 `MINION_BRAIN_DIR` 覆盖(命令里不再硬编码绝对路径)。
- 这层耦合是有意的:`/idea` 的价值就在于**在任何 repo 下都能随手捕获**,所以它必须是全局命令,而不是 minion-brain 的项目级命令。

## Lessons learned

- **Claude Code 的项目级配置由 cwd 唯一决定**。曾设想"从 minion-brain 起一个实例、cd 到别的 repo 就能共用它的 CLAUDE.md/skills"——**行不通**。cd 之后只读 `~/.claude/` + 目标 repo 自己的配置。共用的东西必须落在全局层。
- **停用了四子代理编排**(`deep-reasoner`/`peer-review`/`fast-worker`/`verifier` + SUBAGENTS.md)。原因:开发以 mattpocock skills 为主,那套 skill 自带编排规则(双轴并行、design-it-twice),两套叠加产生歧义。原文存于 KB `archive/subagents/`,含恢复方法。

## 待处理

`master` 工作区有一批未提交改动(memory 层的 PRD/设计文档、diagrams、`docs/agents/` 的 issue-tracker/triage/domain 配置)。其中 SUBAGENTS.md 与 4 个 agent 定义已归档进 KB,不再随 app 走。

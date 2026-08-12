# Index

> 全局目录。任何 AI 查找知识从这里进;每次写入后更新对应条目(标题 + 一句话 + 路径)。

## Base(全局配置源 ★指令层)

- [base/](base/README.md) — 分发到 `~/.claude/` 的全局配置,对**所有 repo** 生效:`CLAUDE.md`(全局偏好)+ `commands/`(`/brain` `/idea` `/general-review`)。装法 `bash scripts/init.sh`(幂等,逐文件 symlink)。开发主力 skills 用 [mattpocock/skills](https://github.com/mattpocock/skills)(外部依赖,装在 `~/.agents/skills/`)

## Preferences(偏好 ★指令层)

- [沟通偏好](wiki/preferences/communication.md) — 中文、极简直接、逐项过审、当场提问
- [工程偏好](wiki/preferences/engineering.md) — MVP 极简、纯文本即真相、指令层保护、软删除、commit/push 硬纪律

## Conventions(规范 ★指令层)

**个人 conventions**(Owner 自己的开发,跨所有个人项目):
- ~~[多模型编排规范](wiki/conventions/agent-orchestration.md)~~ — **已停用(2026-08-03)**。开发改以 mattpocock skills 为主,其 skill 自带子代理编排规则,两套叠加有歧义。配置原文归档于 [archive/subagents/](archive/README.md)

**公司 conventions**(Amazon 内部环境专用,与个人 conventions 分开):
- [Amazon 工作规范](wiki/conventions/amazon-workflow.md) — 生产安全铁律、Brazil/CRUX/Coral 等内部系统入口、包容性语言

## Goals(长期目标 ★指令层)

_暂无_

## Projects(项目上下文)

> 每个 repo 一页,记「为什么存在 / 架构决策 / lessons learned / 与其他项目的关系」。技术栈与构建约定归各 repo 自己的 `CLAUDE.md`。

- [minion-brain](wiki/projects/minion-brain.md) — 第二大脑的 Web App(Next.js+Supabase);与本 KB 的分工决策(KB 当大脑、它当被管理的 app)、`/brain` `/idea` 的后端、四子代理停用记录

## Knowledge(通用知识)

- [连已登录 Chrome 抓取网站的方法](wiki/knowledge/scrape-logged-in-chrome.md) — puppeteer 连登录态 Chrome、`__INITIAL_STATE__` 提数据、小红书反爬/限流对策(为"自主抓取 agent"沉淀)
- 小红书 openclaw 收藏夹 — 81 条笔记各自独立成页,见 [wiki/knowledge/rednote/](wiki/knowledge/rednote/)(每条一个 wiki + 一个 raw,主题:Claude/Fable/Codex/Agent skill/harness/OpenClaw/第二大脑/agent memory);原文存档 [raw/2026/07/rednote/](raw/2026/07/rednote/)

## Skills(操作规程)

- kb-ingest / kb-query / kb-remember / kb-lint — KB 四个核心操作(见 README「四个操作」)
- [awake](skills/awake/SKILL.md) — `@awake <hours>` 用 caffeinate 让 Mac 保持唤醒(含 `keep_awake.sh`)

# Index

> 全局目录。任何 AI 查找知识从这里进;每次写入后更新对应条目(标题 + 一句话 + 路径)。

## Preferences(偏好 ★指令层)

- [沟通偏好](wiki/preferences/communication.md) — 中文、极简直接、逐项过审、当场提问
- [工程偏好](wiki/preferences/engineering.md) — MVP 极简、纯文本即真相、指令层保护、软删除、commit/push 硬纪律

## Conventions(规范 ★指令层)

**个人 conventions**(Owner 自己的开发,跨所有个人项目):
- [多模型编排规范](wiki/conventions/agent-orchestration.md) — Fable 编排、四 subagent 分工、工作流链、代理定义要点与 Codex 安装(原文见 raw)

**公司 conventions**(Amazon 内部环境专用,与个人 conventions 分开):
- [Amazon 工作规范](wiki/conventions/amazon-workflow.md) — 生产安全铁律、Brazil/CRUX/Coral 等内部系统入口、包容性语言

## Goals(长期目标 ★指令层)

_暂无_

## Projects(项目上下文)

_暂无_

## Knowledge(通用知识)

- [批量下载 Chase 对账单 PDF](wiki/knowledge/chase-statement-download.md) — 三步链路,`documentId` ≠ `docKey`
- [批量下载 Bank of America 对账单 PDF](wiki/knowledge/boa-statement-download.md) — 两步链路,四个陷阱(下载限流 / 年份上下文 / 面板名 / 计数器不可信)

## Skills(操作规程)

- kb-ingest / kb-query / kb-remember / kb-lint — KB 四个核心操作(见 README「四个操作」)
- [awake](skills/awake/SKILL.md) — `@awake <hours>` 用 caffeinate 让 Mac 保持唤醒(含 `keep_awake.sh`)

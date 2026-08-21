# Index

> 全局目录。任何 AI 查找知识从这里进;每次写入后更新对应条目(标题 + 一句话 + 路径)。

## Base(全局配置源 ★指令层)

- [base/](base/README.md) — 分发到 `~/.claude/` 与 `~/.codex/` 的全局配置,对**所有 repo** 生效:`CLAUDE.md` + `AGENTS.md`(全局偏好孪生文件,Claude / Codex 各一入口)+ `commands/`(`/brain` `/idea` `/general-review`)+ `agents/` 与 `codex-agents/`(子代理定义各 5 个,主会话不落文件)。装法 `bash scripts/init.sh`(幂等,逐文件 symlink)。开发主力 skills 用 [mattpocock/skills](https://github.com/mattpocock/skills)(外部依赖,装在 `~/.agents/skills/`)

## Preferences(偏好 ★指令层)

- [沟通偏好](wiki/preferences/communication.md) — 中文、极简直接、逐项过审、当场提问
- [工程偏好](wiki/preferences/engineering.md) — MVP 极简、纯文本即真相、指令层保护、软删除、commit/push 硬纪律

## Conventions(规范 ★指令层)

**个人 conventions**(Owner 自己的开发,跨所有个人项目):
- [多模型编排规范](wiki/conventions/agent-orchestration.md) — **已恢复并扩展(2026-08-12)**。六角色分层路由,Claude Code + Codex 双侧对等;三档语义映射 + 代际适配方法;Luna leaf-only 与不在最高档模型(sol/opus)上例行扇出两条硬边界。**双向跨 harness 互调**取第二视角(Claude `peer-review` → `codex exec`,Codex `verifier` → `claude -p`),其中 Codex→Claude 需放宽沙箱是 Owner 知情取舍而非缺陷。2026-08-03 的停用原因(与 mattpocock skills 编排叠加有歧义)已解:只分发 agent 定义、不加无条件引用。Amazon 侧运维细节(Midway/429/cache TTL)已移出本页,见 Amazon 工作规范

**公司 conventions**(Amazon 内部环境专用,与个人 conventions 分开):
- [Amazon 工作规范](wiki/conventions/amazon-workflow.md) — 生产安全铁律、Brazil/CRUX/Coral 等内部系统入口、包容性语言;**Bedrock 上的编排环境**(Midway 过期导致的 401、429 的 RPM/TPM 双桶与 PDT 时段反相关、prompt cache 5 分钟 TTL 的成本阶跃,2026-08-19 从编排页移入)

## Goals(长期目标 ★指令层)

_暂无_

## Projects(项目上下文)

> 每个 repo 一页,记「为什么存在 / 架构决策 / lessons learned / 与其他项目的关系」。技术栈与构建约定归各 repo 自己的 `CLAUDE.md`。

- [minion-brain](wiki/projects/minion-brain.md) — 第二大脑的 Web App(Next.js+Supabase);与本 KB 的分工决策(KB 当大脑、它当被管理的 app)、`/brain` `/idea` 的后端、四子代理编排的停用(2026-08-03)与恢复扩展(2026-08-12)记录

## Knowledge(通用知识)

_暂无_

## Skills(操作规程)

- kb-ingest / kb-query / kb-remember / kb-lint — KB 四个核心操作(见 README「四个操作」)
- [awake](skills/awake/SKILL.md) — `@awake <hours>` 用 caffeinate 让 Mac 保持唤醒(含 `keep_awake.sh`)

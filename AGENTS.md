# Agent Onboarding — 进入本 repo 必读

这是 Owner(Kun)所有 AI 共享的唯一记忆库(纯文件、无服务端)。本文件是**唯一无条件加载**的内容:先记住下面的核心纪律,其余按需去读——**不要预先加载全部文档,用到哪个读哪个**。

## 核心纪律(无条件遵守)

1. **commit 看本次改动整体**:本次只动 `wiki/projects/`、`wiki/knowledge/` → 可 auto commit;一旦触及指令层(`wiki/preferences|conventions|goals/`)或策略文件(PRD/README/AGENTS/CLAUDE/SKILL)→ 整批(含连带 index/log/.gitignore)须 **Owner 明说「可以 commit」才 commit**。**push 永不自行做。**
2. **指令层保护**:改 `wiki/preferences|conventions|goals/` 前必须先出 diff,经 Owner 确认才写。
3. **写入即记账**:每次写 wiki 页,同步更新 `index.md` 对应条目 + `log.md` 追加一行。
4. **矛盾不静默**:与现有页矛盾时当场问 Owner,不擅自择一。
5. **写前必读(硬门)**:任何 KB 写操作(新建/编辑/append 任一 wiki 或 raw 文件)**动手前必须先读 `README.md` 完整铁律 + 对应 `skills/<name>/SKILL.md`**;未读完不得写。核心纪律不能替代完整规程(raw/ 只增不改、frontmatter 必填、`replaces` 机制等细节都在那)。

## 按需加载(用到再读,别预加载)

| 你要做什么 | 读这个 |
|---|---|
| 了解 KB 结构 / 四个操作 / frontmatter 模板 / 完整铁律 | `README.md` |
| 执行某个 kb 操作(ingest/query/remember/lint)或 awake | 对应 `skills/<name>/SKILL.md` 完整规程 |
| 编排多个 subagent(何时派 deep-reasoner/peer-review/fast-worker/verifier) | `wiki/conventions/agent-orchestration.md` |
| 需要 Owner 的工程偏好 / 沟通偏好 / 目标 / 项目上下文 | 从 `index.md` 导航到对应 wiki 页 |
| 干 **Amazon 相关**的活(AWS/Brazil/内部系统) | `wiki/conventions/amazon-workflow.md`(`scope: amazon`)|

> **scope 加载规则**:标 `scope: amazon` 的页**只在处理 Amazon 任务时才读**,做个人项目不必加载(省 context)。其余页(personal 或不带 scope)按上表按需读。

## 环境差异

- **能加载 skill 的 harness(桌面 Claude Code)**:`.claude/skills/` 自动发现,可 `/kb-ingest` 等斜杠触发。
- **不支持 skill / 不支持 `@` 语法的环境(手机 Claude、GPT、GitHub connector、Windows)**:直接读 `skills/<name>/SKILL.md` 真文件照做——行为一致。`.claude/skills/*` 只是指向 `skills/*` 的 symlink,权威原文永远在 `skills/`。

# base/ — 全局配置源(配置态)

这里是**分发到 `~/.claude/`(Claude Code)与 `~/.codex/`(Codex)的全局配置**,对所有 repo 的所有实例生效。
装法:`bash scripts/init.sh`(幂等,逐文件 symlink)。

## 两态之分:`wiki/` 是知识,`base/` 是配置

| | `wiki/`(知识态) | `base/`(配置态) |
|---|---|---|
| 权威性 | **权威原文** | 由 wiki 提炼的**产物** |
| 格式 | KB frontmatter、进 `index.md`、写入记 `log.md` | Claude Code 直接可吃,无 frontmatter |
| 加载 | 按需读 | **每次会话无条件全量加载**(所以要精简) |
| 例 | `wiki/preferences/communication.md` | `base/CLAUDE.md` |

改偏好的正确顺序:先改 `wiki/preferences/`(权威,受指令层保护 → 先给 Owner 看 diff),再同步到 `base/CLAUDE.md`。

## 内容

```
base/
├── CLAUDE.md        → ~/.claude/CLAUDE.md        全局偏好(Claude Code 入口)
├── AGENTS.md        → ~/.codex/AGENTS.md         全局偏好(Codex 入口)
├── agents/          → ~/.claude/agents/*.md      六角色子代理定义(Claude)
├── codex-agents/    → ~/.codex/agents/*.toml     六角色子代理定义(Codex)
└── commands/        → ~/.claude/commands/*
    ├── brain.md         /brain          跨项目全局总览(读 minion-brain app)
    ├── idea.md          /idea           一句话捕获 idea 进 Inbox
    └── general-review.md /general-review 审查非代码变更(文档/配置/内容)
```

`CLAUDE.md` 与 `AGENTS.md` 是**同一份偏好的两个 harness 入口**(两个真文件,不是 symlink),共有小节应逐字相同;漂移由 `kb-lint` 查。子代理的角色→模型映射与代际适配方法见 [wiki/conventions/agent-orchestration.md](../wiki/conventions/agent-orchestration.md)。

`skills/`(KB 自己的 `kb-*` + `awake`)也由 `init.sh` 一并分发到 `~/.claude/skills/`,但它们**不在 base/ 下**——`skills/` 就是权威原文本身,无需编译。

## 三层配置模型

```
~/.claude/            ← 全局层:本目录分发而来 + mattpocock skills。所有项目共用
    ↓ 叠加
<repo>/CLAUDE.md      ← 项目层:由 cwd 决定。技术栈、构建命令、代码约定
    ↓ 按需读
wiki/projects/<repo>.md ← 大脑层:项目为什么存在、架构决策、跨项目关系
```

关键机制:**项目层由 cwd 唯一决定**。在 `Github/foo` 下开发时,Claude 读 `~/.claude/` + `foo/CLAUDE.md`,**不会**自动读 KB 里的东西——所以 `base/CLAUDE.md` 里有一条规则要求主动去读 `wiki/projects/<repo>.md`。

## 不纳入的东西(有意为之)

| 排除项 | 原因 |
|---|---|
| `~/.claude/settings.json` | 含 `awsCredentialExport` 等机器特定路径,无法跨环境 |
| `~/.codex/config.toml` | 含 AWS region、`profile`、per-project `trust_level`,机器特定 |
| `~/.claude/rules/amazon-*` | 公司下发、标注 do-not-delete,可能被其工具维护 |
| `~/.claude/commands/worklog*` | Amazon 工作专用(Quip、内部项目代号),不进个人 repo |
| mattpocock skills | **外部依赖**。由其自带安装器管理在 `~/.agents/skills/`,不 vendor 进来(避免腐烂 + 手动追上游) |

### 因此:新机器需手配的项(已知缺口)

上面两个 config 文件不随 repo 走,所以 `init.sh` 装完后**子代理定义就位、但模型解析仍是默认值**。新机器需手动补(细节见 [agent-orchestration.md](../wiki/conventions/agent-orchestration.md)):

| 文件 | 需补什么 | 不补的后果 |
|---|---|---|
| `~/.claude/settings.json` | `availableModels` 加裸别名(`opus`/`sonnet`/`haiku`/`fable`)+ 各别名解析出的全 ID | 子代理的 `model:` 被**静默替换**成继承模型 |
| 同上 | `ANTHROPIC_DEFAULT_*_MODEL` 按需 pin(注意原生 1M 的 Sonnet 5 / Fable 5 **不加** `[1m]`) | Bedrock 上 `sonnet` 落到 Sonnet 4.5 / 200K |
| `~/.codex/config.toml` | `[model_providers.amazon-bedrock.aws]` 的 `profile` | 退到过期静态凭证 → 401,`mwinit` 救不了 |
| 同上 | `[agents]` 的 `default_subagent_model` / `..._reasoning_effort` | 子代理 model 无兜底,代际升级要逐个文件改 |

这是**有意的取舍**:让这四项随 repo 走需要引入配置合并机制,违反 MVP 极简主义(能用文件+版本控制+文档规则解决的就不建系统)。改为文档化 + `kb-lint` 事后查。

## 依赖

`base/commands/brain.md` 和 `idea.md` 调用 `minion-brain` app 的 CLI。默认路径 `$HOME/Documents/Github/minion-brain`,可用环境变量 `MINION_BRAIN_DIR` 覆盖。

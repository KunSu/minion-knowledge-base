# Operation Log

> Append-only。格式:`日期 | 操作(ingest/remember/lint/edit) | 路径 | 摘要`

2026-07-08 | init | - | KB 骨架创建(README + 4 skills + 目录结构)
2026-07-08 | remember | wiki/preferences/communication.md | 沟通偏好(来自会话沉淀,待 owner 过目)
2026-07-08 | remember | wiki/preferences/engineering.md | 工程偏好(来自会话沉淀,待 owner 过目)
2026-07-08 | remember | wiki/conventions/agent-orchestration.md | 多模型编排规范(源自 SUBAGENTS.md)
2026-07-08 | init | PRD.md | PRD v2.1 放入 repo
2026-07-08 | edit | wiki/preferences/engineering.md | 抽象为项目无关描述;新增版本控制纪律(未经 approve 不 commit、永不自行 push)
2026-07-08 | edit | wiki/conventions/agent-orchestration.md | description 去项目关联
2026-07-08 | ingest | raw/2026/07/subagents-orchestration.md | SUBAGENTS.md 原文入库(owner 手订,已审核落盘)
2026-07-08 | edit | wiki/conventions/agent-orchestration.md | 补全:代理定义要点、Codex 安装、原文链接
2026-07-08 | init | CLAUDE.md | agent 入口(@AGENTS.md)
2026-07-08 | init | AGENTS.md | agent onboarding:加载 README+编排规范+工程纪律
2026-07-08 | edit | skills/kb-ingest/SKILL.md | peer-review 修复:commit 单独请示门
2026-07-08 | edit | skills/kb-remember/SKILL.md | peer-review 修复:commit 单独请示门
2026-07-08 | edit | PRD.md | §5 commit 措辞对齐硬纪律
2026-07-08 | edit | index.md | 刷新两条 blurb
2026-07-11 | edit | wiki/preferences/engineering.md | commit 纪律返工:双门→按内容分级(指令层/策略文件需 approve,projects/knowledge auto),push 仍硬门
2026-07-11 | edit | skills/kb-ingest/SKILL.md, skills/kb-remember/SKILL.md | 收尾条对齐分级 commit
2026-07-11 | edit | PRD.md | §1 加权威源声明;§5 commit 分级;§6 手机端 write==commit 消歧;§3 结构图补 AGENTS/CLAUDE
2026-07-11 | edit | README.md | 权威源声明;铁律#3 补 commit 分级门+push 硬门+手机端;结构图补 AGENTS/CLAUDE
2026-07-11 | edit | AGENTS.md | 硬纪律描述对齐分级 commit
2026-07-11 | edit | log.md | 修正 raw 入库状态(审核中→已落盘)
2026-07-11 | ingest | wiki/preferences/communication.md | 从 ~/.claude/CLAUDE.md 补全:no praise padding、命令/路径/专名英文、不猜方向
2026-07-11 | ingest | wiki/preferences/engineering.md | 从 ~/.claude/CLAUDE.md 补:不可逆操作先确认
2026-07-11 | ingest | wiki/conventions/amazon-workflow.md | 新建:Amazon 生产安全铁律 + 内部系统入口 + 包容性语言(源自 ~/.claude/rules/)
2026-07-11 | init | skills/awake/SKILL.md, skills/awake/keep_awake.sh | awake skill + 脚本存入 repo(源自 ~/.claude/rules/awake.md)
2026-07-11 | edit | index.md | 加 Amazon 工作规范 + Skills 分区(awake)
2026-07-11 | init | .gitignore | 忽略 .DS_Store 及 editor/OS 临时文件
2026-07-11 | edit | PRD.md, README.md | 第2轮 peer-review 后按 Owner 定调:删权威源双向声明(AI 直接读 repo)
2026-07-11 | edit | PRD.md, README.md, wiki/preferences/engineering.md, skills/kb-*/SKILL.md, AGENTS.md | commit 规则简化为「看本次改动整体 + Owner 让 commit 才 commit」
2026-07-11 | edit | index.md, wiki/conventions/{agent-orchestration,amazon-workflow}.md | 个人 convention 与公司 convention 分区(加 scope: personal/company)
2026-07-11 | edit | skills/awake/keep_awake.sh | 定为唯一权威;~/Documents/Code/Agent/ 那份改为 symlink,消除双拷贝 drift
2026-07-11 | init | .claude/skills/ | 5 个 skill 加项目级发现入口(symlink→../../skills/<name>),桌面 Claude Code 可 /kb-* 触发;权威原文仍在 skills/
2026-07-11 | edit | PRD.md, README.md, AGENTS.md | 写清 skills 两条发现路径(harness 走 .claude/skills、手机/connector 读 skills/),行为一致
2026-07-12 | edit | AGENTS.md, CLAUDE.md | 改为 progressive loading:只无条件 load 核心纪律,README/编排规范/偏好降级为按需指针(去掉 3 个 @ 全文展开)
2026-07-12 | edit | PRD.md, README.md, AGENTS.md | 更正 Owner 名:Sunny → Kun
2026-07-12 | edit | AGENTS.md | peer-review 修复:加「写前必读(硬门)」第5条纪律 + scope 加载规则(amazon 仅干 Amazon 活时读)
2026-07-12 | edit | PRD.md, README.md | 同步 AGENTS/CLAUDE 结构块描述为 progressive;frontmatter 模板补 scope 字段定义
2026-07-12 | edit | wiki/conventions/amazon-workflow.md | scope: company → amazon;顶部注明仅干 Amazon 活时才 load
2026-07-12 | edit | .gitignore | 忽略 .obsidian/(本机 Obsidian 配置,不跨机共享)
2026-07-12 | edit | skills/awake/SKILL.md | 多机说明:脚本随 KB 走,以本 skill 目录下 keep_awake.sh 为准
2026-08-14 | remember | wiki/knowledge/chase-statement-download.md, index.md | Chase 对账单批量下载流程(首个 knowledge 页)。三步链路,核心坑是 documentId ≠ docKey。详见页面
2026-08-14 | remember | wiki/knowledge/boa-statement-download.md, wiki/knowledge/chase-statement-download.md, index.md | BoA 对账单批量下载流程 + Chase 页加交叉链接。两步链路,四个陷阱。详见页面
2026-08-19 | edit | wiki/knowledge/statement-acquisition-{chase,boa}.md, wiki/projects/little-minion.md, index.md | 两个获取流程页改名为 statement-acquisition-*(与 issue #49 的 acquisition 用词及既有 Merrill 页对齐,预留每机构一页的家);新建 little-minion project 页承载项目上下文并指向它们。决策:procedure 留在 knowledge/ 而非放 projects/ 子目录——README 规定 projects 每个 repo 一页,而 procedure 是面向机构的机制、已是 3 家且会继续长,属集合

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
2026-08-14 | remember | wiki/knowledge/chase-statement-download.md, index.md | 批量下载 Chase 对账单 PDF 的方法(首个 knowledge 页)。实测 3 账户 × 2022–2026 共 167 份零失败。核心坑:①列表返回的 documentId 不是下载用的 docKey,中间要过一次 dockey/list 换一次性 locator,直接用会得到 HTTP 504 + Invalid DocLocator——且 ~160ms 就返回,是伪装成网关超时的业务错误,不读 body 会误判为限流;②页面原生下载是隐藏 form + target=_self 整页导航,连点多行互相取消(点 7 行只落地 1 份),改走 fetch→blob→a[download] 后稳定串行;③换 docKey 是异步的,靠固定 sleep 拦表单会漏(160ms 只抓到 4/7)。另记:chrome-devtools MCP 连的是本机真实 Chrome、可复用已登录会话(我起初未验证就答「不能访问」是错的),但页面状态会被 Owner 中途改动,每步需先确认;年份枚举 CURRENT_YEAR_MINUS_N;收尾必须用官方清单 diff 本地文件而非按数量猜(当年年份天然不满 12)

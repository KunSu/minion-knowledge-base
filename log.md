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
2026-07-13 | ingest | raw/2026/07/rednote-openclaw-board.md, raw/2026/07/rednote-openclaw-checklist.json | 小红书 openclaw 收藏夹抓取原文存档(84/91 条,56 clean/28 pending 限流/7 missing)+ 增量 checklist
2026-07-13 | ingest | wiki/knowledge/rednote-openclaw-ai-signals.md | 从收藏夹精编 Claude/Fable/Codex/Agent 工程情报(编排/skill/第二大脑)
2026-07-13 | ingest | wiki/knowledge/scrape-logged-in-chrome.md | 连已登录 Chrome 抓取的可复用方法(puppeteer+__INITIAL_STATE__+反爬对策)
2026-07-13 | edit | index.md | Knowledge 分区填入两个新知识页
2026-07-13 | ingest | raw/2026/07/rednote-openclaw-board.md, rednote-openclaw-checklist.json | 限流恢复后降速补抓 28 条 pending 全部成功 → 84 条全 clean,回填 raw+checklist
2026-07-13 | edit | wiki/knowledge/rednote-openclaw-ai-signals.md | 补 OpenClaw 专题章(记忆/安全/省token/必装skills/多agent) + agent memory 前沿 + Harness Engineering;页头状态改为 84 全 clean
2026-07-13 | edit | raw/2026/07/rednote-openclaw/, wiki/knowledge/rednote-openclaw/ | 按 Owner 要求返工:废弃聚合(删 board 大文件 + 精编页 + 索引),改为每个 note 单独成文——81 条各一个 raw + 一个 wiki,无任何聚合
2026-07-13 | edit | raw/2026/07/rednote/, wiki/knowledge/rednote/ | 目录 rednote-openclaw → rednote;删 checklist.json;修内部引用
2026-07-13 | remember | wiki/preferences/engineering.md | 新增「Web 抓取/外部数据采集」偏好(不硬刚反爬/优先__INITIAL_STATE__/连登录Chrome/每个原子单元单独成文)——指令层,已 Owner 批准
2026-07-13 | edit | 文件名重构 raw/wiki/rednote/ | 去掉 noteId 前缀,改纯标题 slug;noteId 移入 frontmatter id:;重复标题才加短后缀
2026-07-13 | edit | wiki/preferences/engineering.md, skills/kb-ingest/SKILL.md, AGENTS.md, README.md | 分层返工(调研 Anthropic/Cursor 官方后):撤销 engineering 里放错层的 web 抓取段;「每个原子单元单独成文」移入 kb-ingest 铁律;AGENTS 指针表加抓取场景触发行;README 新增「内容放哪层」分层判据 + id 字段
2026-07-13 | edit | AGENTS.md | 指针表整体改为「场景词打头」风格(左列=触发场景而非人视角任务名,提升 AI 按需加载命中率)+ 加引导句
2026-08-03 | create | base/, scripts/init.sh | 建立全局配置源:base/CLAUDE.md(由 wiki/preferences 编译,新增工程偏好+开发工作流两节)+ base/commands/(brain/idea/general-review);init.sh 幂等逐文件 symlink 到 ~/.claude,已安装 9 个链接
2026-08-03 | create | wiki/projects/minion-brain.md | 首个 project context 页:KB 当大脑 / minion-brain 当被管理的 app 的分工决策 + cwd 决定项目级配置的 lesson
2026-08-03 | archive | archive/subagents/, archive/commands/ | 停用四子代理编排(SUBAGENTS.md + 4 agents,与 mattpocock skills 编排规则冲突)与自有 /code-review command(与 mattpocock skill 撞名被遮蔽);全局残留已备份删除
2026-08-03 | edit | index.md | 新增 Base 段与 Projects 段首个条目;多模型编排规范标记为已停用
2026-08-12 | edit | base/agents/, base/codex-agents/, base/AGENTS.md, base/CLAUDE.md, scripts/init.sh, skills/kb-lint/SKILL.md, wiki/conventions/agent-orchestration.md, index.md, archive/README.md | 恢复并扩展多模型编排:六角色(+Explore/scanner)Claude+Codex 双侧对等定义;base/AGENTS.md 作 Codex 全局偏好入口(与 CLAUDE.md 孪生);init.sh 加 agents 分发(4→6 段);kb-lint 加检查项 8(孪生漂移)+9(编排配置一致性)。全量实测(读 transcript 真实 model,不信子代理自报)抓到三个静默失败:①availableModels 缺裸别名 → model:haiku 被换成 opus-5;②给原生 1M 的 Sonnet 5 错加 [1m] → ID 落在白名单外被静默降级;③Codex 的 bedrock provider 缺 profile → 退到 ~/.aws/credentials [default] 过期静态凭证,401 且 mwinit 救不了。三者均已修复并复测通过;Claude 侧 opus/sonnet/haiku/fable 四别名、Codex 侧 sol/terra/luna 三模型 + 五 agent 定义 + AGENTS.md 生效全部验证
2026-08-12 | edit | base/README.md, AGENTS.md, base/CLAUDE.md, base/AGENTS.md, base/agents/, base/codex-agents/, scripts/init.sh, skills/kb-lint/SKILL.md, wiki/conventions/agent-orchestration.md | 过 /code-review 双轴后修复 12 项:恢复被我静默删掉的两条运行守则(异步派发、Fable 下安全扫描固定 Opus——指令层未经确认的删除);base/AGENTS.md 补回 skill 编排优先级(S5 的保险);base/README.md 更新为双 harness + 新增「新机器需手配项」表(把 1M 缺口文档化);AGENTS.md 指针表去掉过期的「Fable 编排」;init.sh 修 banner 谎报目标、备份路径加 claude/codex 来源前缀(实测两侧同名文件会互相覆盖)、删死代码、[N/6] 改计数器变量;deep-reasoner Claude 侧 effort xhigh→high(与 Codex 对称,且原文档自陈 xhigh 无增益);fast-worker.toml 删掉与 [agents] 默认重复的 model/effort(实测继承确认 terra/low);benchmark 依据四处全文重述压成指针;kb-lint 检查项 8/9 改指针式并扩到覆盖十二个 agent 文件漂移

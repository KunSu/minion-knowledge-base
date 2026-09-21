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
2026-08-03 | create | base/, scripts/init.sh | 建立全局配置源:base/CLAUDE.md(由 wiki/preferences 编译,新增工程偏好+开发工作流两节)+ base/commands/(brain/idea/general-review);init.sh 幂等逐文件 symlink 到 ~/.claude,已安装 9 个链接
2026-08-03 | create | wiki/projects/minion-brain.md | 首个 project context 页:KB 当大脑 / minion-brain 当被管理的 app 的分工决策 + cwd 决定项目级配置的 lesson
2026-08-03 | archive | archive/subagents/, archive/commands/ | 停用四子代理编排(SUBAGENTS.md + 4 agents,与 mattpocock skills 编排规则冲突)与自有 /code-review command(与 mattpocock skill 撞名被遮蔽);全局残留已备份删除
2026-08-03 | edit | index.md | 新增 Base 段与 Projects 段首个条目;多模型编排规范标记为已停用
2026-08-12 | edit | base/agents/, base/codex-agents/, base/AGENTS.md, base/CLAUDE.md, scripts/init.sh, skills/kb-lint/SKILL.md, wiki/conventions/agent-orchestration.md, index.md, archive/README.md | 恢复并扩展多模型编排:六角色(+Explore/scanner)Claude+Codex 双侧对等定义;base/AGENTS.md 作 Codex 全局偏好入口(与 CLAUDE.md 孪生);init.sh 加 agents 分发(4→6 段);kb-lint 加检查项 8(孪生漂移)+9(编排配置一致性)。全量实测(读 transcript 真实 model,不信子代理自报)抓到三个静默失败:①availableModels 缺裸别名 → model:haiku 被换成 opus-5;②给原生 1M 的 Sonnet 5 错加 [1m] → ID 落在白名单外被静默降级;③Codex 的 bedrock provider 缺 profile → 退到 ~/.aws/credentials [default] 过期静态凭证,401 且 mwinit 救不了。三者均已修复并复测通过;Claude 侧 opus/sonnet/haiku/fable 四别名、Codex 侧 sol/terra/luna 三模型 + 五 agent 定义 + AGENTS.md 生效全部验证
2026-08-12 | edit | base/README.md, AGENTS.md, base/CLAUDE.md, base/AGENTS.md, base/agents/, base/codex-agents/, scripts/init.sh, skills/kb-lint/SKILL.md, wiki/conventions/agent-orchestration.md | 过 /code-review 双轴后修复 12 项:恢复被我静默删掉的两条运行守则(异步派发、Fable 下安全扫描固定 Opus——指令层未经确认的删除);base/AGENTS.md 补回 skill 编排优先级(S5 的保险);base/README.md 更新为双 harness + 新增「新机器需手配项」表(把 1M 缺口文档化);AGENTS.md 指针表更新编排那行;init.sh 修 banner 谎报目标、备份路径加 claude/codex 来源前缀(实测两侧同名文件会互相覆盖)、删死代码、[N/6] 改计数器变量;deep-reasoner Claude 侧 effort xhigh→high(与 Codex 对称,且原文档自陈 xhigh 无增益);fast-worker.toml 删掉与 [agents] 默认重复的 model/effort(实测继承确认 terra/low);benchmark 依据四处全文重述压成指针;kb-lint 检查项 8/9 改指针式并扩到覆盖十二个 agent 文件漂移
2026-09-21 | edit | wiki/conventions/amazon-workflow.md, index.md, ~/.local/bin/cdd(非 repo), ~/.ssh/config(非 repo), /Users/kunsu/littleMinion/CLAUDE.md(非 repo) | 按 Owner 批准新增 Cloud Desktop endpoint 路由规范:cdd 加第二台(main = `Host cdd` 默认 / adhoc = `Host cdd-adhoc` 须显式 --adhoc),规则同步写入 littleMinion 的新建 root CLAUDE.md(那边原本没有任何 CLAUDE/AGENTS,规则放别处不会被自动加载;littleMinion 不是 git repo,无法 commit)。刻意不做「自动挑一台活着的」——两台的 tmux session 同名(cc-$CLAUDE_CODE_SESSION_ID)、各有独立 cdd-logs 与 Midway cookie,走错机器时 tail/peek/kill 静默指向另一台的另一个任务。脚本侧经两轮对抗式 review 共 11 条发现,10 修 1 判误报:①`cdd -e` 缺参数死循环(shift 2 在只剩一参时一个都不 shift 且脚本无 set -e,下一轮又匹配同一个 -e);②endpoint 校验原在加载时跑,CDD_ENDPOINT 写坏连 cdd -h 都被打死,改为 _resolve_endpoint 延后到 help 短路之后;③参数守卫初版只挂 ls/tail/doctor,漏了 peek/attach/detach/kill 四个收一参的(cdd peek 80 --adhoc 静默落 main),泛化成 _max_args;④未知子命令改用 declare -F cmd_<名> 探测而非再列一份清单。判误报的那条:review 称 ssh config 里 main 块注释也有因果错误,核对后确认 main 块原文准确(%h 展开的是解析后 HostName,真正要求是前缀不能与 Host * 相同),说错的是我新写的 adhoc 段、已修。主机名只在 ~/.ssh/config,本 repo public 故脚本与本页均不写。遗留:tools/cdd/README.md+.html 仍只描述单 endpoint,待更新

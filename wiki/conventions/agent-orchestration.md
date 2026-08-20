---
type: convention
title: 多模型编排规范
description: Owner 的 subagent 分工与工作流链,Claude Code + Codex 双侧对等(已装入全局配置)
scope: personal
resource: https://www.developersdigest.tech/blog/fable-5-orchestrator-model-playbook
tags: [claude, codex, subagents, orchestration, model-routing]
timestamp: 2026-08-12T00:00:00Z
---

# 多模型编排规范

> 原文:[raw/2026/07/subagents-orchestration.md](../../raw/2026/07/subagents-orchestration.md)(Owner 手订 SUBAGENTS.md)
> GPT-5.6 档位依据:[2026.07 Codex GPT-5.6 Model and Reasoning Effort Benchmark](https://w.amazon.com/bin/view/Users/kyouhei/codex/codex_gpt_5_6_model_effort_benchmark/)(Amazon 内部,22 次调用矩阵)

核心思路:贵模型只坐编排位(决策错误会向下游放大),便宜模型干活(错误局部、重试便宜)。

**同一套角色语义,两个 harness 各自落地。** Claude 用 `~/.claude/agents/*.md`(frontmatter),Codex 用 `~/.codex/agents/*.toml`。

## 角色映射(2026-08 代际)

| 角色 | Claude `model` | Claude `effort` | Codex `model` | Codex effort |
|---|---|---|---|---|
| 主会话(编排) | `opus`(Opus 5) | high | `openai.gpt-5.6-sol` | medium |
| `deep-reasoner` | `opus` | high | `openai.gpt-5.6-sol` | high |
| `peer-review` | `sonnet` | high | `openai.gpt-5.6-terra` | high |
| `fast-worker` | `sonnet` | low | *(继承 `[agents]` 默认)* | *(terra/low)* |
| `verifier` | `sonnet` | high | `openai.gpt-5.6-terra` | high |
| `Explore` / `scanner` | `haiku` | medium | `openai.gpt-5.6-luna` | medium |

`fast-worker` 的 Codex 侧刻意不写 `model`/`effort`——它就是 `[agents]` 的默认档,写死会让代际升级要改每个文件。**只有偏离默认的角色才显式写。**

Codex 侧 `Explore` 的对等角色叫 `scanner`(`Explore` 是 Claude 内置名,同名覆盖才有意义)。

**显式指定优先于一切默认**:`/model fable` + `/effort max`(Claude,两个独立旋钮,**不是** `fable/max` 斜杠语法);`-c model='"openai.gpt-5.6-sol"' -c model_reasoning_effort='"high"'`(Codex)。

默认工作流链:deep-reasoner 定方案 →(重大变更)peer-review 二意见 → fast-worker 执行 → verifier 验证 → 编排者裁决。简单任务跳过前两步;是否「重大」由编排者判断(涉及架构、数据模型、外部依赖、安全 → 重大)。

## 两条硬边界

1. **Luna 只做叶子(leaf-only)**。用 `luna` 的角色**不得** spawn / steer / message / wait / consolidate 其他 agent,所有跨 agent 通信走 Terra 或 Sol 父节点。这是**能力边界**,不是风格偏好——Luna 不暴露编排所需能力,也不得改 model catalog 去伪造。编排位必须 Terra 或 Sol。
2. **不在 Sol 上做例行并行扇出**。并行会放大延迟、token 和挂起线程的影响。Sol 只用作**单次定向挑战者**,在后果严重时。benchmark 实测:`terra/low` 质量打平 `sol/high`(均 100/100)但快 81.6%(5.42x),且完成时间 CV 仅 2.52%——并行可预测性最好。

升级路径:`terra/low → terra/high → sol/high`(routine → demanding → critical)。因**实质不确定性、风险、或验证失败**才升级,不因任务长就升级。升级是**交接不是重启**:把已有结论、证据、失败的检查、未决问题交给更强的模型,不要从头再查。

## 三档语义(跨代际不变的部分)

模型名会过期,角色语义不会。规范记语义,映射表按代际重写:

| 语义档 | 当前(2026-08) | 用途 |
|---|---|---|
| 旗舰推理 | Opus 5 / `sol` | 架构、复杂 bug、算法、最高风险裁决 |
| 均衡主力 | Sonnet 5 / `terra` | 日常实现、评审、验证、并行 worker |
| 快速叶子 | Haiku 4.5 / `luna` | 搜索、提取、分类;不编排 |

## 代际适配方法

两侧机制不同,不能用同一招:

- **Claude —— 用别名,自动继承。** frontmatter 写 `model: opus|sonnet|haiku|fable`,不写具体 ID。新代际发布时 agent 文件**一个字不用改**,只改 `~/.claude/settings.json` 的 `modelOverrides` / `ANTHROPIC_DEFAULT_*_MODEL`。
- **Codex —— 只吃具体 ID,必须手动改。** 官方 subagent 文档所有示例都是具体 ID,无别名支持。为把改动收到一处,`~/.codex/config.toml` 的 `[agents]` 设 `default_subagent_model` / `default_subagent_reasoning_effort` 兜底,只在必须偏离默认的角色文件里写 `model`。

**新代际怎么定档:重跑 benchmark,不靠发布公告排位。** 方法可复用上述内部 benchmark:两个固定任务(仓库修复 + 证据推理),跑 模型×effort 矩阵,比质量 / 首动作延迟 / 总时长 / token / 可靠性。注意 benchmark 的自陈局限:100/100 打平只说明在中等难度 fixture 上等价,**不等于最大能力相同**;要找 Terra/Sol 与 high/xhigh 的质量边界需要更难的题。

经验:**effort 不是线性延迟旋钮**。`xhigh`/`max` 常无质量增益只增延迟(实测 `luna/max` 比 `luna/high` 慢 54.3%、多用 61% 输入 token,质量零提升)。先调 effort 再换模型,但别默认拉满。

**编排位若显式切到 Fable**(`/model fable`):安全扫描类任务直接固定到 Opus,绕开 Fable 的安全分类器,避免 refusal 重试延迟。默认编排位是 Opus 5 时用不上这条,但显式切换的能力一直保留,所以规则仍然有效。

## 1M 上下文

- **Claude**:`[1m]` 后缀**按变量读、不按模型读**。Bedrock 上 `ANTHROPIC_DEFAULT_OPUS_MODEL` 不带后缀就是 200K,即使别处同模型带了后缀。另注意 Bedrock 上 `sonnet` 别名默认解析到 **Sonnet 4.5**(不是 5),须显式 pin。
- **Codex**:**没有 1M 开关**。窗口由模型本身决定;`model_context_window` 只声明 Codex 假设的窗口(影响何时压缩),不改变服务端真实窗口。

## 静默失败陷阱(2026-08-12 实测确认)

四个都**不报错**。共同的验证纪律:**读 transcript 里的真实 `message.model` 字段,别信子代理自报**——它常报成继承来的模型。

```bash
cd /tmp/probe && claude -p --agents '{"p":{"description":"probe","prompt":"Reply: OK","model":"haiku","tools":[]}}' "Dispatch p."
# 然后读 ~/.claude/projects/<dir>/<session>/subagents/agent-*.jsonl 里的 message.model
```

**1. `availableModels` 白名单必须同时列裸别名和全 ID。** 配 `enforceAvailableModels: true` 时,白名单只列 `claude-haiku-4-5` 而不列 `haiku`,`model: haiku` 的子代理会被静默替换成继承模型(实测落到 `claude-opus-5`)。别名和它解析后的全 ID **两者都要在白名单里**。

**2. 原生 1M 的模型不能加 `[1m]` 后缀。** Sonnet 5 和 Fable 5 原生就是 1M(官方文档:"Sonnet 5 always runs with the 1M window on these providers and never needs the suffix")。加了会产出白名单里不存在的 ID → 被拦掉 → 静默退回继承模型。**注意这与上一节 Opus 需要后缀的规则相反**,按模型分别处理。

**3. Codex 的 Bedrock provider 必须显式指定 profile。** `[model_providers.amazon-bedrock.aws]` 只设 `region` 不设 `profile`,SDK 会退到 `~/.aws/credentials` 的 `[default]` 静态凭证;那份凭证过期后就是 401 `The security token included in the request is invalid`,而且 **`mwinit` 刷新救不了**——它走的不是 Midway→STS 那条链。正确配置指向带 `credential_process` 的 profile(本机是 `codex-DO-NOT-DELETE`)。

所以 **401 有两条独立成因**,别只查 Midway:
- Midway cookie 过期(~2 小时)→ `mwinit -o`
- 凭证链走错 profile → 查 `~/.aws/config` 的 `credential_process`,用 `AWS_PROFILE=<name> aws sts get-caller-identity` 二分定位

**4. `[agents]` 默认值缺失会让 `fast-worker` 跑到最贵档。** 它刻意不写 `model`/`effort` 靠继承(见映射表),所以 `~/.codex/config.toml` 的 `[agents]` **必须存在且等于 terra/low**。缺了就继承主会话 = `sol/medium` ——最贵的档,意图的反面,且不报错。这是「省一处维护」换来的代价:新机器必须配这一项(见 [base/README.md](../../base/README.md)「新机器需手配的项」)。

## 为什么两侧各写一份(不共用正文)

两个 harness 的 agent 格式**互不兼容**:Claude 吃 Markdown + YAML frontmatter(正文即 body),Codex 吃独立 TOML(正文在 `developer_instructions` 内联字符串)。都不支持从外部文件 include 正文。

行为约束正文实测重叠 95%(verifier)/ 86%(deep-reasoner)/ 79%(fast-worker),但 **`peer-review` 只有 18%、`Explore`↔`scanner` 49%** —— 后两个的差异是真实职责差异,不是重复:

- `peer-review`:Claude 侧那份的核心是「怎么 shell 出去调 Codex 取第二意见」;Codex 侧**自己就是那个第二视角**,不能再调自己。
- `Explore`↔`scanner`:Codex 侧有 Luna 的 leaf-only 能力边界,Claude 侧的 haiku 没有;Claude 侧有「覆盖内置 Explore」的说明,Codex 侧没有内置可覆盖。

**决策(2026-08-12):保持两份手写,不引入生成步骤。** 抽共享正文需要构建脚本 + 衍生产物,违反 MVP 极简主义;而角色固定为 6 个(其中主会话不落文件,两侧各 5 个定义文件)、正文改动频率极低(七月定稿至今只因 model 行动过)。**代价由 `kb-lint` 检查项 8 承担** —— 手同步的漂移必须靠 lint 兜住,这是本决策成立的前提。

若某天手同步成了负担,再上生成器 —— 那时它是被需求推出来的,不是预先设计的。

## 代理定义要点

- 定义文件在 `base/agents/`(Claude)与 `base/codex-agents/`(Codex),由 `scripts/init.sh` symlink 到 `~/.claude/agents/` 和 `~/.codex/agents/`。项目级同名覆盖全局。
- **只分发定义,不加无条件引用**。subagent 定义是声明式的:放着不改变编排行为,只在 `description` 匹配时才派发。这样与 mattpocock skills 自带的编排规则(`/code-review` 双轴、`/design-an-interface` design-it-twice)不冲突——skill 有自己编排时走 skill 的,没有时才落到这六个角色。(2026-08-03 停用旧版就是因为 `@SUBAGENTS.md` 无条件全局加载产生歧义,见 `archive/README.md`。)
- **只读角色靠机制约束,不靠 prompt 措辞。** 覆盖内置 `Explore` 时若不写 `tools`,会把内置的只读约束一并解掉,静默拿到写权限。
- **但两侧只读强度不等价**:Codex 的 `sandbox_mode = "read-only"` 是运行时强制;Claude 的 `tools` 白名单只是不给写工具,**白名单里一旦有 `Bash`,只读就是空话**(可 `sh -c "echo > f"`)。所以 `Explore` 的白名单刻意不含 `Bash`——`Read`/`Glob`/`Grep` 足够定位代码。
- 其余四个角色(`deep-reasoner`/`fast-worker`/`verifier`/`peer-review`)**不限制写权限**,靠 prompt 约束行为:
  - `verifier` 要跑 build/test,那些必须写文件——用只读沙箱会把 build 一起挡掉,所以两侧都不设。它的约束是「不改被审查的变更」。
  - `peer-review` 要能起原型验证替代方案,同理。
  - 只有 `Explore`/`scanner` 是真只读角色(前者靠 `tools` 白名单,后者靠 `sandbox_mode`)。
- **四个角色两侧都写「不再向下派发」**(`deep-reasoner`/`fast-worker`/`verifier`/`peer-review`):嵌套委派会让编排失控且难追踪。Codex 侧写在 `developer_instructions`,Claude 侧写在正文 Rules。`Explore`/`scanner` 不需要这条——前者白名单里没有 Agent 工具,后者的 leaf-only 条款更严,两者机制上就派不出去。
- **跨 harness 互调取第二视角**(双向):Claude 侧的 `peer-review` shell 出去调 `codex exec`;Codex 侧的 `verifier` 反过来调 `claude -p --model sonnet --effort high`。两个方向都靠独立进程保证视角独立(看不到对方的 CLAUDE.md/skills),对方不可用时**必须显式声明,禁止编造**。
  - **两个方向的代价不对称**:Claude→Codex 零成本(Claude 侧无沙箱限制、凭证已在环境里)。Codex→Claude **需要放宽 Codex 沙箱**,两层原因实测确认:①Claude Code 启动要写 `~/.claude/settings.json`,默认与 `workspace-write` 沙箱都拒绝;②即使放开该路径,Bedrock 模式下还要跑 toolbox 换 STS 凭证,那要伸到沙箱外。已验证可行的是最宽的那档;更窄的组合(`workspace-write` + 只读全盘 + `~/.claude` 可写)未验证,应优先试。
  - **Owner 于 2026-08-12 在知悉代价后选择保留这个方向**(为了让 Codex 的验证结论也过一遍 Claude 复核)。这是**有意的取舍,不是缺陷**——后续审查不要当 bug 删掉。约束:放宽只发生在**父进程启动时**,子代理自己不得放宽;未获放宽时报 "Claude unavailable: sandbox denied" 而不是绕路。
  - 替代方案(当时评估过、未采用):由编排者串行派两侧 `verifier` 再自行汇总,不需要任何权限放宽。若哪天觉得沙箱代价不值,回到这个方案。
- `peer-review` 跑在 Sonnet 上、经 Codex CLI 取第二意见(`codex` 不是合法 Claude model 值)。其价值来自**视角独立**(独立进程,看不到 Claude 的 CLAUDE.md/skills),不来自模型规格——所以用 terra/high 而非 sol。Codex 不可用时**必须显式声明,禁止编造**。
- `verifier` 只返回 PASS/FAIL + 证据,不做修复。

## 委派契约

每次派子代理都要给:目标与用户可见的问题;artifact 句柄(路径 / ID / diff / 测试输出,**不是完整 transcript**);明确的所有权边界与允许的操作;成功标准、所需证据、停止条件;输出格式(含如何报告未知、冲突、被阻塞);禁止嵌套委派与未授权的外部/生产写入。

自由度匹配风险:探索型给问题 + 证据门槛;可重复型给结构化输入输出契约;脆弱的验证工作给精确检查项。

## 并发与生命周期

- **优先异步派发子代理,不要阻塞等待最慢的 worker。**
- 只并行**独立读**或所有权互不重叠的工作。同文件/同记录的写必须串行,生产写入永不并行。
- 用**单一指定写入者**;worker 和 verifier 通常只返回证据或建议 patch。
- 完成的子代理及时关闭(实测已完成线程在显式关闭前仍占用线程配额)。
- 不用投机 worker 占满并发,留容量给集成和验证。成功标准与证据满足即停止扇出。
- Claude 侧默认并发上限 20(`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS` 可调);Codex 侧 `agents.max_concurrent_threads_per_session`。

## Token 与延迟优化

- worker 默认最低档(Claude `effort: low` / Codex `terra/low`)。
- 只传任务相关上下文,优先给路径和精确证据摘录,不重放完整对话历史。
- 要**简洁结构化发现**,不要打磨过的独立报告。
- 升级时复用 worker 产出。合并分歧后再升级:一个聚焦的 terra/high verifier 通常好过把每个 worker 都重跑到高 effort。
- 共享前缀(约定文档、repo map)吃 prompt caching,worker 成本再降约一半。
- **不要在会话中途换模型**——会失效 prompt cache,下一轮约 5× 成本。只在 task / subagent / session 边界路由。
- 不索取隐藏思维链;要可检查的决策、假设、证据、验证。别让子代理「完整展示推理过程」(会触发 reasoning_extraction 分类器)。

## Amazon 环境提示

`codex exec` 或 Claude Code 报 401 / 403 / "security token expired" / "Could not load credentials" 通常是 **Midway 过期**,不是 OAuth 问题——`/login` 在 3P provider 模式下不可用,跑 `mwinit -o` 重试。Midway cookie 有效期约 2 小时。**`mwinit` 刷了还报 401 就是凭证链走错 profile**(见上「静默失败陷阱」#3)。

429 在 Bedrock 上分两种,对应**两个独立令牌桶**(按 `账号 × region × 模型` 维护,独立检查):`Too many requests`(RPM,与请求大小无关)和 `Too many tokens`(TPM)。**实测近 8 天 12 次真实 429 里 11 次是 RPM**——所以请求大小不是主因,`[1m]` 也不是触发器。

配额按模型分池,这带来两条可操作的结论:
- **`fallbackModel` 首位放另一个模型族**(如 Sonnet 5),限流时才能降级到**未被争用的桶**;放另一个 Opus 等于换到同族的拥挤桶。
- 把 Explore / 机械任务下沉到 haiku/luna 不只省钱,也是把负载分到不同配额池。

**实测发现 429 与自身负载反相关**:12 次全部落在 09:47–15:11 PDT,而该时段吞吐比零事故的深夜时段**轻 7–10 倍**,6/12 次发生在「前 60 秒一个请求都没发」时。强推断是共享配额在太平洋工作时段被其他租户争用(账号是否多租户共享未直接核验)。**最强杠杆是把重活挪出 09:00–15:00 PDT**,配置只能做优雅降级。

**prompt cache 的真实成本来自 5 分钟 TTL 到期**:Claude Code 只用 5 分钟档(`ephemeral_1h = 0`)。按距同 session 上一请求的间隔分组,5 分钟处是干净阶跃——间隔 >5min 的请求平均 cache_creation 从 4k 跳到 187k(>30min 则 352k)。**3% 的请求制造了约 30% 的缓存写入量**:多 session 轮转时每个 session 空转超 5 分钟就 TTL 到期,下一轮按 1.25× 重写整个约 35 万 token 前缀。

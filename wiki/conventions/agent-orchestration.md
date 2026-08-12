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

三个都**不报错**。共同的验证纪律:**读 transcript 里的真实 `message.model` 字段,别信子代理自报**——它常报成继承来的模型。

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

## 代理定义要点

- 定义文件在 `base/agents/`(Claude)与 `base/codex-agents/`(Codex),由 `scripts/init.sh` symlink 到 `~/.claude/agents/` 和 `~/.codex/agents/`。项目级同名覆盖全局。
- **只分发定义,不加无条件引用**。subagent 定义是声明式的:放着不改变编排行为,只在 `description` 匹配时才派发。这样与 mattpocock skills 自带的编排规则(`/code-review` 双轴、`/design-an-interface` design-it-twice)不冲突——skill 有自己编排时走 skill 的,没有时才落到这六个角色。(2026-08-03 停用旧版就是因为 `@SUBAGENTS.md` 无条件全局加载产生歧义,见 `archive/README.md`。)
- Claude 侧均不限制 `tools`(保留 shell/脚本能力),靠 prompt 约束行为;Codex 侧 `peer-review`/`verifier`/`scanner` 加 `sandbox_mode = "read-only"`。
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

`codex exec` 或 Claude Code 报 401 / 403 / "security token expired" / "Could not load credentials" 是 **Midway 过期**,不是 OAuth 问题——`/login` 在 3P provider 模式下不可用,跑 `mwinit -o` 重试。Midway cookie 有效期约 2 小时。

429 在 Bedrock 上分两种:`Too many requests`(请求数)和 `Too many tokens`(每分钟吞吐,更常见)。配额按模型分池,所以把 Explore / 机械任务下沉到 haiku/luna 不只省钱,也是把负载分到不同配额池。

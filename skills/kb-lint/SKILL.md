---
name: kb-lint
description: Health-check the knowledge base. Use when the owner says "lint my KB", "check the KB", or periodically after heavy ingest/remember activity.
---

# kb-lint — 健康检查

## 检查项

1. **断链**:wiki 页之间的 markdown 链接指向不存在的文件
2. **index 一致性**:wiki 页缺 index.md 条目;index 条目指向不存在的页;被 replaces 取代的页仍留在 index
3. **frontmatter 合法性**:缺 type/title/description/timestamp;type 枚举非法;timestamp 格式错误
4. **replaces 完整性**:replaces 指向不存在的页;replaces 成环(A 取代 B,B 取代 A)
5. **矛盾探测**:同主题页面间的表述冲突(尽力而为,列出可疑对)
6. **孤儿页**:没有任何入链且不在 index 的页
7. **raw 完整性**:raw 文件缺 resource 溯源;raw 被 wiki 之外引用
8. **孪生文件漂移**(两组,只报 diff 不自动合并——哪边权威由 Owner 定):
   - `base/CLAUDE.md` ↔ `base/AGENTS.md`:同一份偏好的两个 harness 入口。**允许不同的只有这三处**:①开头的前言引用块(各自的 symlink 目标与项目层叠加规则);②「模型 / effort」整节(该节内容本身就是 harness 机制:别名+effort vs 具体 ID+`-c` 覆盖);③「开发工作流」里的 harness 独有事实:「开发以 mattpocock/skills 为主」及其安装路径(**Claude 侧独有——Codex 不装 mattpocock skills**)、`~/.claude/skills/`、`CLAUDE.md` vs `AGENTS.md`。
     其余一律应逐字相同。两条实质规则两侧都必须在:「skill 自带编排时遵循 skill 自己的结构」、「Amazon 环境提示」的 Midway 401 两条成因(**401 对两个 harness 都适用,不是 Codex 专有**)
   - `base/agents/*.md` ↔ `base/codex-agents/*.toml`:五个角色文件(主会话不落文件)。**这一项是「两侧各写一份」这个决策成立的前提,不能省** —— 见 [agent-orchestration.md](../../wiki/conventions/agent-orchestration.md)「为什么两侧各写一份」。查:
     - 两侧角色集合是否一一对应(`Explore`↔`scanner` 是刻意的改名,其余同名)
     - 行为约束(Rules / 返回格式 / 禁止事项)是否等价。**改了一侧忘改另一侧就是本项要抓的漂移。**
     - 允许的差异只有三类:①机制字段(`model`/`effort`/`tools`/`sandbox_mode`)。两条相关判据:
       - **只有 `Explore`/`scanner` 是只读角色**。其余四个都需要写权限(`verifier` 要跑 build/test,`peer-review` 要起原型),两侧都不该设只读——若发现给它们加了 `sandbox_mode = "read-only"` 或只读白名单,那是 bug:会把 build 一起挡掉。
       - **只读的两种手段强度不等价**:Codex 的 `sandbox_mode = "read-only"` 是运行时强制;Claude 的 `tools` 白名单只是不给写工具,**白名单里一旦有 `Bash`,只读就是空话**(可 `sh -c "echo > f"`)。所以 `Explore` 的白名单必须不含 `Bash`。②`peer-review` 的 Codex 调用段(Claude 侧独有——Codex 侧自己就是第二视角);③明确的 harness 独有事实:「开发以 mattpocock/skills 为主」及其安装路径(Claude 侧独有——Codex 不装它)、`Explore`/`scanner` 的 Luna leaf-only 边界(Codex 侧独有)、「覆盖内置 Explore」说明(Claude 侧独有)。**这三类之外的任何不一致都要报。**
     - 委派约束特例:`Explore`/`scanner` 不必有「不再向下派发」——前者白名单无 Agent 工具,后者 leaf-only 条款更严,机制上就派不出去。**其余四个角色两侧都必须有该条。**
     - **跨 harness 互调**:Claude 的 `peer-review` 调 `codex exec`,Codex 的 `verifier` 调 `claude -p --model sonnet --effort high`。两处都必须有「对方不可用时显式声明、禁止编造」;缺这句就是漂移。
     - `verifier.toml` 里那段「需要放宽 Codex 沙箱」的说明是 **Owner 2026-08-12 知情后的取舍,不是待修缺陷**——不要报它、也不要建议删掉回调。但**要报**两件事:①该说明被删或被弱化;②子代理定义里出现自行放宽沙箱的指令(放宽只应发生在父进程启动时)。
9. **编排配置一致性**(agents)。判据与原理见 [wiki/conventions/agent-orchestration.md](../../wiki/conventions/agent-orchestration.md)——**该页是唯一正文,本项只列要查什么**:
   - `~/.claude/agents/` 与 `~/.codex/agents/` 的 symlink 是否失效
   - Claude agent 的 `model` 用别名而非硬编码 ID(见该页「代际适配方法」)
   - Codex agent 的 `model` ID 仍在当前模型目录内;与 `[agents]` 默认值重复的角色文件应删掉冗余键(同上节)
   - 该页映射表与实际 agent 文件一致
   - **Luna 边界**:用 `luna` 的角色未被赋予编排/派发职责(见该页「两条硬边界」)
   - 四个**静默失败**陷阱是否复现(见该页同名小节):白名单缺别名或缺解析后全 ID、原生 1M 模型误加 `[1m]`、Codex bedrock provider 缺 `profile`、**`[agents]` 默认值缺失或不等于 terra/low**(会让刻意继承的 `fast-worker` 跑到最贵档)
   - **别名 pin 是否到位**:用了 `model: sonnet` 的角色依赖 `ANTHROPIC_DEFAULT_SONNET_MODEL` 显式 pin 到 Sonnet 5——Bedrock 上该别名默认解析到 **Sonnet 4.5 / 200K**(见该页「1M 上下文」)。缺 pin 不报错,只是静默用了旧模型

## 输出与修复

- **自动修复(无需确认)**:仅限 index.md 条目的增补/摘除
- **只报告**:其余全部列成清单(路径 + 问题 + 建议),由 Owner 决定;修复动作走 kb-remember 的规则(指令层照旧需确认)
- 结果追加到 log.md 一行:`日期 | lint | - | N 项问题`

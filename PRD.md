# Minion Knowledge Base — PRD v2.1(MVP)

> v2.1:ingest 改为「当场审核、原子落盘」,砍掉 candidates/、trust 字段、kb-review skill;supersedes 更名 replaces。
> v1.0 全量设计(server/索引/多用户)存档于 `MEMORY_DESIGN.md`,作未来蓝图,MVP 不实现。
> 2026-07-08 · Owner: Sunny

## 1. 愿景(不变)

所有 AI(Claude Code / Codex / Cursor / ChatGPT)共享同一份 Memory,用户永不重复介绍自己的背景、偏好、项目。用户只负责扔内容,第二大脑自己维护自己。

## 2. MVP 定义:只做两件事

1. **Knowledge Base**:一个 **private** git repo(https://github.com/KunSu/minion-knowledge-base),基于 [karpathy-llm-wiki](https://github.com/Astro-Han/karpathy-llm-wiki) 的 raw→wiki 编译模式 + [Google OKF v0.1](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing) 格式标准。
2. **一套 kb- skills(共 4 个)**:AI 与 KB 交互的全部方式,skills 文件就放在 repo 里(自包含)。无任何服务端。

## 3. Knowledge Base 结构

```
minion-knowledge-base/
├── raw/                  # 原文存档(经审核的 ingest 原料,append-only,不参与检索)
│   └── YYYY/MM/<slug>.md
├── wiki/                 # 知识页(进入即视为可信——因为一切都经过你审核)
│   ├── preferences/      # ★ 指令层:改动需 owner 确认
│   ├── conventions/      # ★ 指令层:改动需 owner 确认
│   ├── goals/            # ★ 指令层:长期目标,改动需 owner 确认
│   ├── projects/         # 项目上下文,AI 自由写
│   └── knowledge/        # 通用知识,AI 自由写
├── index.md              # 全局目录(渐进导航入口,机器维护)
├── log.md                # append-only 操作日志(机器维护)
└── skills/               # kb-* 四个 skill(repo 自包含;手机场景直接读这些文件照做)
```

**格式:OKF v0.1 合规。** frontmatter = 标准字段 + 一个扩展:

```yaml
---
type: preference | convention | goal | project | knowledge | raw   # OKF 唯一必填
title: ...
description: 一句话摘要
resource: https://...        # 溯源(raw 的原始 URL / 知识页的来源引用)
tags: [nextjs]
timestamp: 2026-07-08T10:00:00Z
replaces: [路径]             # 可选:本页取代旧页(偏好演进);被取代页从 index 摘除,git 保留历史
---
```

路径即身份;页面互链用普通 markdown 链接;版本史 = git;检索 = grep + index 导航,无向量库。

## 4. Skills(全部交互,共 4 个)

| Skill | 触发 | 行为 |
|---|---|---|
| **kb-ingest** | 「ingest 这个 URL/文件/文本」 | 抓取原文 → 编译成知识页草稿(引用溯源、更新交叉链接)→ **当场给你审核**:与现有知识的冲突/矛盾/不确定处显式标出 → 你确认后 raw + wiki + index/log **原子落盘**;不确认则什么都不写 |
| **kb-query** | 「我的 KB 里关于 X 有什么」 | index 导航 + grep 检索 wiki 页,答案必须引用具体页面;raw 不参与检索 |
| **kb-remember** | 「记住这个」/ AI 判断值得沉淀 | 从当前会话提取 lesson/decision/preference → 写入对应 wiki 页(新建或追加)→ 更新 index/log。目标是指令层(preferences/conventions/goals)时先出 diff 等确认;发现与现有知识矛盾时当场问你(顺手标 replaces) |
| **kb-lint** | 「lint 我的 KB」 | 断链、index 缺项、frontmatter 非法、replaces 环、矛盾探测;index 条目自动修,其余报告 |

盘点不设专门 skill:AI 改了什么看 git log;冲突和矛盾在 ingest/remember 当场解决,不留异步队列。

## 5. 治理规则(写进 skill 规则,零基础设施)

- **需 owner 确认(先出 diff)**:`wiki/preferences|conventions|goals/` —— 指令层影响所有后续 AI 行为
- **AI 自由写**:`wiki/projects|knowledge/`;`raw/` 只可追加不可修改
- **机器维护**:`index.md`、`log.md`
- **外部内容进 wiki 的唯一通路**:kb-ingest 的当场审核;审核不过,一个字节都不落盘
- 每次写入更新 log.md 一行;git commit 由 AI 会话正常提交

## 6. 手机访问(零建设)

手机版 Claude(或 GPT)接 **GitHub connector** 读写同一个 private repo:query = 读文件,remember = commit 写回。skills 即文档——手机上第一句说「读 `skills/kb-query.md` 然后照着查 X」,或把 kb 规则放进一个 Claude Project 的 instructions。repo 必须 private(个人记忆),connector 授权后访问 private repo 无障碍。

## 7. 交付物与验收

交付:KB repo 骨架(目录 + index/log + OKF 模板 + README + 4 个 skills)推到 KunSu/minion-knowledge-base(private);内容为空,owner 自己 ingest。

**README 即 AI 契约**:repo 根 README 用一页写清结构、四个操作、frontmatter 模板和六条铁律——任何 AI(含无 skill 加载能力的手机端)读完 README 即知如何维护与交互;skills/*/SKILL.md 是各操作的完整规程,README 是其摘要。二者冲突以 SKILL.md 为准。

> 骨架已生成于 `minion-brain/minion-knowledge-base/`,推送前:`mv minion-knowledge-base ~/Documents/Github/ && cd ~/Documents/Github/minion-knowledge-base && git init && git add -A && git commit -m "init: KB skeleton" && gh repo create KunSu/minion-knowledge-base --private --source=. --push`

验收(全部在 Claude Code 里演示):
1. 「ingest <某 URL>」→ 编译稿呈现、冲突处标出 → 确认 → raw/ + wiki 页 + index/log 一次性出现;拒绝 → 仓库无任何变化
2. 「我的 KB 里关于 X 有什么」→ 回答并引用到页
3. 「记住:<一条 preference>」→ 出 diff → 确认 → preferences/ 页更新
4. 「lint」→ 报告干净或列出问题
5. 手机 Claude 经 GitHub connector 读 skills 文件后完成一次 query

## 8. 明确不做(未来再说)

MCP server · 向量索引/Supabase · token/auth · 周报邮件 · client 隔离 · 多用户 · 硬删除 · candidates 异步队列 · trust 分级。演进蓝图见 MEMORY_DESIGN.md。

## 9. 成功指标(30 天)

- 重复向 AI 解释背景/偏好的次数趋近 0
- kb-remember 周使用 ≥ 5 次(写回真的顺手)
- 指令层零次未经确认的改动(git log 可审计)
- ingest 当场审核平均 ≤ 2 分钟/条(不然说明编译稿质量不行)

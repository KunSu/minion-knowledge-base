---
type: project
title: little-minion(Financial)
description: 个人财务 app;以银行对账单 PDF 归档为输入源。本页只放项目上下文与教训,获取流程与技术栈另有归属
tags: [little-minion, personal-finance, pdf-extraction]
timestamp: 2026-08-19T00:00:00Z
---

# little-minion(Financial)

个人财务 app。Dashboard 与 Cash Flow 两个页面的数字**从归档的银行对账单 PDF 渲染出来**,而不是手工维护。

技术栈与构建约定归该 repo 自己的 `CLAUDE.md` / `AGENTS.md`;**issue 才是需求的真相来源**,本页不复述。

## 与本 KB 的关系

三条边界,分清了就不会把东西写错地方:

| 内容 | 归属 |
|---|---|
| 怎么从各机构把对账单弄下来(含陷阱) | 本 KB `wiki/knowledge/statement-acquisition-*.md`(每机构一页) |
| 需求、验收条件、切片顺序 | little-minion 的 GitHub issues |
| 技术栈、构建、测试约定 | little-minion repo 自己的 `CLAUDE.md` |
| 项目为什么存在、跨会话教训 | 本页 |

**获取流程页(每机构一页):**

- [Chase](../knowledge/statement-acquisition-chase.md) —— 三步链路,`documentId` ≠ `docKey`
- [Bank of America](../knowledge/statement-acquisition-boa.md) —— 两步链路,四个陷阱
- **Merrill(券商)—— 还在 repo 之外**,存于本机 `~/Documents/little-minion-financial-config/`。该机构的下载模型是「勾选 N 份 → 合并成一个有页数上限的 PDF」,与两家银行都不同。**搬进 KB 是待办。**

## 归档的形态(消费方需要知道的)

对账单归档在 `~/Downloads/` 下按用途分两个目录(银行 / 房贷),命名统一为:

```
<归属>_<银行-类型-尾号>_<对账结算日>.pdf
```

归属只有两种:Owner 个人、或与配偶共有。**归属以 Owner 确认为准,不能从对账单的姓名栏推断** —— 信用卡对账单只列 primary cardholder,单个名字反推不出账户共有关系(实测踩过并被 Owner 纠正)。

**一份文档可能覆盖两个账户。** 某机构的支票与储蓄是一份 "Checking & Savings" 合并对账单,两个账户 ID 下载到同一份文件;已验证同期的两份提取正文逐字相同,重复副本已删除。**因此文件数 ≠ 账户数,解析器不能靠文件名尾号判定账户归属**,必须读文档内部的分区,一份文档产出两条账户记录。否则被合并掉的那个账户会整个从 dashboard 里消失。

各账户的线上可得区间差异很大(房贷保留期明显长于存款/信用卡),早于机构保留期的需人工向机构申请,脚本做不到。具体区间见上面两页。

## 教训(跨会话,别重犯)

**抽取器要针对「流水线自己的 PDF reader」设计,不是针对命令行 `pdftotext`。** 两者产出的文本不同,而且差异只在少数文档上暴露 —— 用 CLI 验证通过不等于流水线里能跑通。

**「所有单元测试绿」和「抽取器正确」是两个不同的断言。** 验收测试是**把整个归档过一遍**,不是测试套件变绿。

**批量操作的成功计数器不可信。** 进程内的计数器统计的是「请求成功 + 触发了动作」,不是结果落地。收尾必须回到文件系统或权威清单对账。这条在上面两个获取流程页里都有实例。

**空结果要先自证。** 拿到「0 条」时,先确认是数据源真的没有,还是自己的选择器/查询没匹配上 —— 把自己的 bug 当成数据缺失报出去是最坏的失败模式。实测踩过:某账户的折叠面板标题与其他账户不同,精确匹配导致 51 份看起来像「机构没有数据」。

## 硬约束

**任何提交的产物里不得出现账户名、账号或金额。** 这是 issue #49 的验收条件之一,适用于 KB 页、脚本、handoff 文档在内的一切落盘内容。需要账户内部标识或 session token 时**现场从页面读取**,不要写进文件,也不要落盘会话凭证(实测:把实时 cookie 写盘再用 curl 重放会被权限层拦下,拦得对)。

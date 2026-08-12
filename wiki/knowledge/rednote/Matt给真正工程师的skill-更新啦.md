---
type: knowledge
id: 6a37ecfc000000002003bcfa
title: "Matt给真正工程师的skill，更新啦"
description: "小红书 openclaw 收藏笔记精编:Matt给真正工程师的skill，更新啦"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/6a37ecfc000000002003bcfa?xsec_token=ABqvH36tMAADKvvL07KWfPdwz_QVSW40GvFvpr3S4lAIo=&xsec_source=pc_board
tags: [rednote, openclaw, claudecode, AI编程, vibecoding, aicoding, matt, REDSkill]
timestamp: 2026-07-13T00:00:00Z
---

# Matt给真正工程师的skill，更新啦

> 来源:小红书 openclaw 收藏夹 · 作者 薛定谔的拉格朗日余项 · Jun 21 日本
> 原文存档:[Matt给真正工程师的skill-更新啦.md](../../../raw/2026/07/rednote/Matt给真正工程师的skill-更新啦.md)

## 要点

Matt Pocock 的 skill 合集 mattpocock/skills 出正式版了。我介绍过的 grill-with-docs（先问透需求）、tdd（先写会失败的测试）就来自他，全球 13 万 star、420 万下载。

他排的头号改动是省 token：skill 描述砍了 63%。靠开关 disable-model-invocation 把 skill 设成「只有你喊才来」，它的说明就不再进模型挑 skill 要读的上下文。Matt 说这是最大的结构改动。

顺手还把重复的零件抽成三块能共用、别处一句话就能引用的 skill：grilling 是动手前对计划连环追问、把需求问透；domain-modeling 把各叫各的概念理成统一叫法；codebase-design 是一套「深模块」设计词，讲怎么把接口做小、实现做厚，也更好测。

更要紧的是，skill 按「谁能叫它」分两类：你喊的负责编排，打出名字才来；它自己够得到的是可复用纪律，对上任务自动取。这类只有 5 个：diagnosing-bugs、tdd、domain-modeling、codebase-design、grilling。

最招牌的新 skill 是 writing-great-skills：Matt 花六七个小时，配一份术语表，把写 skill 的心法编了进去，照着抄就行。

skill 一多就记不住用哪个，才有 ask-matt：一个入口，把所有 skill 怎么配合讲给你。Matt 直说，拆这么多类你得多操点心，它正是来抵这点摩擦的。

零碎的还有：diagnose 改名 diagnosing-bugs、新增 resolving-merge-conflicts 收 git 冲突、删掉 caveman 和 zoom-out。装或更新都一行 npx skills add mattpocock/skills，首次先跑 /setup-matt-pocock-skills。

Matt 定的调没变：模型始终是你手里的工具，由你指挥。省下的 context 也没浪费，全留给它干正事：设计好代码、修掉难 bug，顺带把 skill 写得更像样。

## 标签

#claudecode #AI编程 #vibecoding #aicoding #matt #REDSkill

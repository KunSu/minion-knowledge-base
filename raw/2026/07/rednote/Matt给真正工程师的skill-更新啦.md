---
type: raw
id: 6a37ecfc000000002003bcfa
title: "Matt给真正工程师的skill，更新啦"
description: "小红书 openclaw 收藏夹笔记原文:Matt给真正工程师的skill，更新啦"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/6a37ecfc000000002003bcfa?xsec_token=ABqvH36tMAADKvvL07KWfPdwz_QVSW40GvFvpr3S4lAIo=&xsec_source=pc_board
tags: [rednote, openclaw, claudecode, AI编程, vibecoding, aicoding, matt, REDSkill]
timestamp: 2026-07-13T00:00:00Z
---

# Matt给真正工程师的skill，更新啦

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/6a37ecfc000000002003bcfa?xsec_token=ABqvH36tMAADKvvL07KWfPdwz_QVSW40GvFvpr3S4lAIo=&xsec_source=pc_board
- **作者**: 薛定谔的拉格朗日余项
- **日期**: Jun 21 日本
- **标签**: #claudecode #AI编程 #vibecoding #aicoding #matt #REDSkill

## 正文

Matt Pocock 的 skill 合集 mattpocock/skills 出正式版了。我介绍过的 grill-with-docs（先问透需求）、tdd（先写会失败的测试）就来自他，全球 13 万 star、420 万下载。
	
他排的头号改动是省 token：skill 描述砍了 63%。靠开关 disable-model-invocation 把 skill 设成「只有你喊才来」，它的说明就不再进模型挑 skill 要读的上下文。Matt 说这是最大的结构改动。
	
顺手还把重复的零件抽成三块能共用、别处一句话就能引用的 skill：grilling 是动手前对计划连环追问、把需求问透；domain-modeling 把各叫各的概念理成统一叫法；codebase-design 是一套「深模块」设计词，讲怎么把接口做小、实现做厚，也更好测。
	
更要紧的是，skill 按「谁能叫它」分两类：你喊的负责编排，打出名字才来；它自己够得到的是可复用纪律，对上任务自动取。这类只有 5 个：diagnosing-bugs、tdd、domain-modeling、codebase-design、grilling。
	
最招牌的新 skill 是 writing-great-skills：Matt 花六七个小时，配一份术语表，把写 skill 的心法编了进去，照着抄就行。
	
skill 一多就记不住用哪个，才有 ask-matt：一个入口，把所有 skill 怎么配合讲给你。Matt 直说，拆这么多类你得多操点心，它正是来抵这点摩擦的。
	
零碎的还有：diagnose 改名 diagnosing-bugs、新增 resolving-merge-conflicts 收 git 冲突、删掉 caveman 和 zoom-out。装或更新都一行 npx skills add mattpocock/skills，首次先跑 /setup-matt-pocock-skills。
	
Matt 定的调没变：模型始终是你手里的工具，由你指挥。省下的 context 也没浪费，全留给它干正事：设计好代码、修掉难 bug，顺带把 skill 写得更像样。
#claudecode #AI编程 #vibecoding #aicoding #matt #REDSkill

## 图片(8)

- https://sns-web-i10.rednotecdn.com/202607131513/2e46b20bad942b08d98e556a0027b932/spectrum/1040g34o321m9hhhsn46g5nosbr9g8cigms37g20!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/9bb6788a4af873ae3152712f459a9f11/spectrum/1040g34o321m9hddq6u0g5nosbr9g8ciggc38d3g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/48470a09b84c3676449356950d96ff5f/spectrum/1040g34o321m9hhhsn43g5nosbr9g8cignnjo6e8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/ab792d4048639a2dfb44b2e1c73fb20f/spectrum/1040g34o321m9hhhsn4405nosbr9g8cigge68huo!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/9da485cc0da7dadf90d72400d8b851bc/spectrum/1040g34o321m9hhhsn44g5nosbr9g8cig302fc8o!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/418f5f151bb2e5f469e5033f9d5f829c/spectrum/1040g34o321m9hhhsn4505nosbr9g8cigsom16ig!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/3395f64e4b2386dbc7ae49e1f14a70bd/spectrum/1040g34o321m9hhhsn45g5nosbr9g8cigetpd6fo!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/ee094a2e6e9afb88910be2bfcea5c8b7/spectrum/1040g34o321m9hhhsn4605nosbr9g8cig9voq1go!nd_dft_wlteh_webp_3?src=A

---
type: raw
id: 69c8942a000000001a02b398
title: "用 Auto Research 优化Skill的正确方式"
description: "小红书 openclaw 收藏夹笔记原文:用 Auto Research 优化Skill的正确方式"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69c8942a000000001a02b398?xsec_token=ABjWuHNX0zciy9ub4LsD-t62xrffc-FE3HZaGaeZJgWIw=&xsec_source=pc_board
tags: [rednote, openclaw, AISkill, AutoResearch, Evals, Karpathy, AI工具]
timestamp: 2026-07-13T00:00:00Z
---

# 用 Auto Research 优化Skill的正确方式

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/69c8942a000000001a02b398?xsec_token=ABjWuHNX0zciy9ub4LsD-t62xrffc-FE3HZaGaeZJgWIw=&xsec_source=pc_board
- **作者**: 奥森木
- **日期**: Edited at Mar 28
- **标签**: #AISkill #AutoResearch #Evals #Karpathy #AI工具

## 正文

用 Karpathy 的 Auto Research 优化 AI Skill 的真实经历。三次踩坑，每次都以为找到了捷径，结果都翻车了。
	
第一次：直接把 Skill 丢给工具，让它自动生成测试和评判标准，跑了一夜。分数蹭蹭涨，但仔细一看——Skill 根本没变好。因为评判标准是机器编的，衡量的是错误的东西。
	
第二次：接入了 Hamel 的 evals-skills，输入质量确实提升了。但评判标准还是没改，自己也没看过一条输出。好的弹药 + 歪的瞄准镜 = 还是打偏。
	
第三次：老老实实学到"三个鸿沟"框架——理解鸿沟、规范鸿沟、泛化鸿沟。在跑任何自动化之前，先手动读输出、归纳失败模式、写评判标准、手动校准。然后才启动自动优化。这次终于有效了。
	
核心教训：你不能自动化跳过理解。总有人要先手动搞懂问题出在哪，那个人就是你。
	
这个道理不只适用于 AI，做产品也一样——没亲自看过用户反馈就上线功能，跟没看过输出就跑优化循环，本质上是同一个错误。
	
#AISkill #AutoResearch #Evals #Karpathy #AI工具 提示词优化 #产品方法论 #AI开发

## 图片(10)

- https://sns-web-i10.rednotecdn.com/202607131517/5d4757ce84f569164d997532e998651f/notes_pre_post/1040g3k831u9du1m42i905pjdpov3cmhnuhmblrg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/c2332a8aa2ddc313768934df6053ad4f/1040g00831u9du1eo2a205pjdpov3cmhn225ah3g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/0d047795f71fea5e1561c17f0d80af0d/notes_pre_post/1040g3k031u9i91obia505pjdpov3cmhn1jgh79g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/4a82ca3006c7704ca992aecc23a19fe8/notes_pre_post/1040g3k031u9i91obia405pjdpov3cmhnt1u3qv8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/92ae7a588974279ad8c73d5dc316d918/notes_pre_post/1040g3k831u9du1m42ibg5pjdpov3cmhnc6gro30!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/2f6bec71c0877ba075f708e141790d86/notes_pre_post/1040g3k031u9i91obia5g5pjdpov3cmhngade968!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/f18d5b8e59d8e0ccf78c062e1b934b13/notes_pre_post/1040g3k031u9i91obia605pjdpov3cmhn3at0sgo!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/2f900e965a72ad37d79fe92cd4a67d44/notes_pre_post/1040g3k031u9i91obia6g5pjdpov3cmhndjim5dg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/bab2a8767746735b70e91779d49dd7f8/notes_pre_post/1040g3k831u9du1m42i805pjdpov3cmhnr98rmno!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131517/98378d59c0d1a21e147644c0211e7731/notes_pre_post/1040g3k831u9du1m42ic05pjdpov3cmhn66uiei8!nd_dft_wlteh_webp_3?src=A

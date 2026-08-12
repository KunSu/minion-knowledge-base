---
type: raw
id: 6a332b7f0000000017028e0b
title: "人类满分程序员的 Skill Repo 又更新了‼️"
description: "小红书 openclaw 收藏夹笔记原文:人类满分程序员的 Skill Repo 又更新了‼️"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/6a332b7f0000000017028e0b?xsec_token=ABLeARoL15iEHYnrkXNXfBhv-5pAM3VbgldEzzln2jFKs=&xsec_source=pc_board
tags: [rednote, openclaw]
timestamp: 2026-07-13T00:00:00Z
---

# 人类满分程序员的 Skill Repo 又更新了‼️

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/6a332b7f0000000017028e0b?xsec_token=ABLeARoL15iEHYnrkXNXfBhv-5pAM3VbgldEzzln2jFKs=&xsec_source=pc_board
- **作者**: 趴在关键词上捡钱
- **日期**: Jun 17 四川

## 正文

省流版：npx skills add mattpocock/skills
已经安装过旧版的，最简单的办法也是重新安装，新版能省 63% Token消耗。
	
我最喜欢的更新是/ask-matt，以后斜杠一下就由本尊亲自掏出Skill接龙🐲
	
这次更新背后有一套完整的动作链：
	
  先发现Leitwort
	
他意识到一个高密度概念词会进入Agent的思考轨迹，反复引导模型行为。比如/teach里的zone of proximal development，最近发展区。这个词只在 Skill里出现几次，但Agent会反复复述它，并据此调整教学难度。
	
 接着落实到 /writing-great-skills
	
有人问/writing-great-skills是怎么写出来的。他说花了6小时和Agent一起思考，定义了一个术语表，用它编码自己喜欢的心智模型，然后写进Skill。他把自己的专家语言压缩成可复用的概念系统。概念！概念！概念！接上了！
	
 然后碰上Skills文档的结构问题
	
他抱怨Skills文档有缺口。他想要三层调用：人类调用、Skill调用、模型调用。
	
因为有些Skill应该给人类手动调用，有些Skill应该只给其他Skill复用，有些Skill才应该让模型自动发现。
	
 再然后就是v1发布
	
调用分成两层：人类手动调用和模型自动调用。
	
人类手动调用，比如/ask-matt、/grill-with-docs、/to-prd、/to-issues。它们主要是流程入口，发生在AFK之前，这时需要人类在场。
	
模型自动调用，比如/grilling、/domain-modeling、/codebase-design、/diagnosing-bugs。它们会被反复模型拉起，主要发生在AFK阶段，这时模型在全权工作。
	
评论区有人问63% token成本下降到底怎么来的。Matt说很多Skill从模型调用改成人类调用，同时缩短了description。因为模型的description会进入上下文，模型每个session都要加载这些skill metadata。他把这个叫context load。
	
可以理解成：人类多担一点，模型少背一点，Token降！
	
最后就是别来我评论区喷Matt，无论是网红还是技术，你们哪一样是能做到全球影响力做到Top的？原地当一个☝️

## 图片(14)

- https://sns-web-i10.rednotecdn.com/202607131513/44a069649c3898af37e7bdde3406a94c/notes_pre_post/1040g3k0321hj80otne2g5p97n43aml93bo9sa0o!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/782e3fd123187073568b81ac2b2d99ce/notes_pre_post/1040g3k0321hj30q77u305p97n43aml93dksu36g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/d3b1df541a05eabde9522edc4655625f/notes_pre_post/1040g3k0321hj30q77u3g5p97n43aml93477av1g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/e566d3726a09b3a312e7b53bfdbdca34/notes_pre_post/1040g3k0321hj30q77u405p97n43aml93dtc5268!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/a9ed879c0e18af472f9c0639d0e113ab/notes_pre_post/1040g3k0321hj30q77u4g5p97n43aml93tjiv3h0!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/c542807ddd68777751144e3167a9e77e/notes_pre_post/1040g3k0321hj30q77u505p97n43aml93k4eufjg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/9e6bfe15159c46d673a5d444e1b46af1/notes_pre_post/1040g3k0321hj30q77u5g5p97n43aml93i3qm0vo!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/d190ca5fc9b43897b82e44d4e60d1802/notes_pre_post/1040g3k0321hj30q77u605p97n43aml93dasdmo0!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/6213a5be4e1ddb6659450fa9e26ed5fe/notes_pre_post/1040g3k0321hj30q77u6g5p97n43aml93qo2br7o!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/941a083486e999f165bbc49b3a6ebe8f/notes_pre_post/1040g3k0321hj80otne005p97n43aml93766f60g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/ada16517d9a3101fee148b36d8c31f82/notes_pre_post/1040g3k0321hj80otne0g5p97n43aml93e33bu50!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/af2f07adafc137aff872a85ce7efdf0f/notes_pre_post/1040g3k0321hj80otne105p97n43aml93lqck4c0!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/bfb66f6c751117548844ed86f0a36bca/notes_pre_post/1040g3k0321hj80otne1g5p97n43aml93vck1818!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/e0b4cdea4b4d0289bc370e415f236c08/notes_pre_post/1040g3k0321hj80otne205p97n43aml93682j2go!nd_dft_wlteh_webp_3?src=A

---
type: knowledge
id: 6a332b7f0000000017028e0b
title: "人类满分程序员的 Skill Repo 又更新了‼️"
description: "小红书 openclaw 收藏笔记精编:人类满分程序员的 Skill Repo 又更新了‼️"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/6a332b7f0000000017028e0b?xsec_token=ABLeARoL15iEHYnrkXNXfBhv-5pAM3VbgldEzzln2jFKs=&xsec_source=pc_board
tags: [rednote, openclaw]
timestamp: 2026-07-13T00:00:00Z
---

# 人类满分程序员的 Skill Repo 又更新了‼️

> 来源:小红书 openclaw 收藏夹 · 作者 趴在关键词上捡钱 · Jun 17 四川
> 原文存档:[人类满分程序员的-Skill-Repo-又更新了.md](../../../raw/2026/07/rednote/人类满分程序员的-Skill-Repo-又更新了.md)

## 要点

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

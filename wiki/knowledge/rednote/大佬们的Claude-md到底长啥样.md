---
type: knowledge
id: 69dcf168000000002103a737
title: "大佬们的Claude.md到底长啥样？"
description: "小红书 openclaw 收藏笔记精编:大佬们的Claude.md到底长啥样？"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69dcf168000000002103a737?xsec_token=ABpVizOUloSKGeME4WkByoG2DGH7Macq2Ixh2kGRDC_P4=&xsec_source=pc_board
tags: [rednote, openclaw, 开发者选项, 开发, claudecode, claudecode技巧, claudecode经验]
timestamp: 2026-07-13T00:00:00Z
---

# 大佬们的Claude.md到底长啥样？

> 来源:小红书 openclaw 收藏夹 · 作者 hi.lyn · Apr 13
> 原文存档:[大佬们的Claude-md到底长啥样.md](../../../raw/2026/07/rednote/大佬们的Claude-md到底长啥样.md)

## 要点

我把 GitHub 上能找到的 Claude Code 配置仓库翻了个遍。

awesome-claude-code 38k stars、ykdojo 的 45 条 tips、wshobson 的 57 个生产级命令——最让我意外的不是里面有什么，而是那些真正在用 Claude Code 做严肃工程的人，CLAUDE.md 都很短。

HumanLayer 团队的基准是 60 行以内。Anthropic 官方文档说目标是 2000 tokens 以内。John Lindquist 把配置从 7584 tokens 压到 3434，节省了 54%，同时 Claude 找东西更准了。

其实逻辑很清楚。

CLAUDE.md 不是写给人看的 README，它每次对话都会完整注入。你写了 200 行「请写好干净的代码」「遵循最佳实践」「添加必要注释」，Claude 每条消息都要先读一遍这些废话，然后照它本来就会做的事去做。白白烧掉 token，还没有任何增量效果。

大佬们真正在写的是什么？Claude 自己猜不到的东西。

比如你的测试命令是 npm run test:e2e 而不是默认的 npm test。比如你们用 pnpm 不用 npm，但 package.json 里没有明确标注。比如端口是 3001 不是默认 3000。这些才是 Claude 没有上下文就会犯错的地方。

有一个方法叫删除测试法：对 CLAUDE.md 里的每一行，问自己「删掉这行，Claude 还会犯这个错吗？」答案是不会——直接删。

剩下的结构就很简单了：一句话说清楚项目是什么，写出那几条 Claude 真的猜不到的命令和约定，复杂的文档用 @docs/guide.md 语法引用出去，主文件只做索引。

还有一个捷径：/init——让 Claude Code 自己分析你的项目生成初始配置，再用删除测试法过滤一遍。比从头写快很多。

## 标签

#开发者选项 #开发 #claudecode #claudecode技巧 #claudecode经验

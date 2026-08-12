---
type: knowledge
id: 69d503e0000000001d01e2c0
title: "女神来搞AI架构了，果然一人公司得俩人才行"
description: "小红书 openclaw 收藏笔记精编:女神来搞AI架构了，果然一人公司得俩人才行"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69d503e0000000001d01e2c0?xsec_token=ABkouyRCeWx4HN2srtVfa_Y0Rks7-Jmh3aB2Bqbx4pDYo=&xsec_source=pc_board
tags: [rednote, openclaw, AI, 人工智能, GitHub开源项目, MillaJovovich, 程序员日常, 效率工具, AI记忆系统, 生化危机]
timestamp: 2026-07-13T00:00:00Z
---

# 女神来搞AI架构了，果然一人公司得俩人才行

> 来源:小红书 openclaw 收藏夹 · 作者 动察Beating · Apr 7
> 原文存档:[女神来搞AI架构了-果然一人公司得俩人才行.md](../../../raw/2026/07/rednote/女神来搞AI架构了-果然一人公司得俩人才行.md)

## 要点

那个一路打穿世界的爱丽丝Milla Jovovich和老友Ben Sigman在GitHub上开源了一个叫MemPalace的AI记忆系统。上线48小时，狂揽3800+ Stars，最离谱的是它在标准benchmark（LongMemEval）上打出了 100% 的满分！这也是目前所有 AI 记忆系统里（不论免费付费）第一个做到的。

现在的系统喜欢让AI提取总结，然后把原始聊天扔掉。但这样你丢掉了为什么选这个方案的权衡过程。MemPalace 的做法是保留所有原始文本 + 优秀的向量检索。

下面是一些insights：

🗑️ 痛点：别再让你的AI变成垃圾堆

用过AI深度工作的人都有共鸣，你跟AI聊了几个月，产出了无数架构、方案和灵感。但当你想找回“当初为什么这么决定”时，传统的关键词搜索根本找不到

Milla吐槽说文件夹就像一个巨大的仓库，所有文件就像一堆写着日期和名字的垃圾。

🏛️ 灵感：古希腊的记忆宫殿

为了解决这个痛点，Milla从古希腊演说家背诵长篇演讲的记忆宫殿术中找到了灵感。她亲自花了好几个月设计出了一套极致逻辑的架构，然后由工程师Ben将其代码化：

• Wing（侧翼）：代表一个人或一个大项目

• Room（房间）：具体的细分主题（比如：权限、部署）

• Closet（壁橱）：压缩后的摘要，指向原始内容

• Drawer（抽屉）：一字不差的原始文件

• Halls & Tunnels（走廊与隧道）：用来在同主题或跨项目之间自动建立关联

👑 核心黑科技：AAAK 压缩。

这是整个项目最亮眼的设计，他们发明了一种叫 AAAK 的压缩技术：

• 30倍无损压缩

• 全模型原生支持

• 极度省钱，一年记住所有聊天数据的成本大概只要 $10

💡 总结：MemPalace 不仅是一个满分开源项目，更是一个极其优雅的产品设计示范。它证明了需求来源于有洞察力的需求，而AI提效也不是减少时间，而是激发需求。

## 标签

#AI #人工智能 #GitHub开源项目 #MillaJovovich #程序员日常 #效率工具 #AI记忆系统 #生化危机 #Claude #ChatGPT #科技干货 #干货分享

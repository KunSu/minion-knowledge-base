---
type: raw
id: 6a48812d000000002200b7ff
title: "如何给Claude Fable 5搭一个第二大脑"
description: "小红书 openclaw 收藏夹笔记原文:如何给Claude Fable 5搭一个第二大脑"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/6a48812d000000002200b7ff?xsec_token=ABYufUkcegbSYNldP6e2XsOstNowYxSQ5VRNb3Z6prckM=&xsec_source=pc_board
tags: [rednote, openclaw, Claude, ClaudeCode, Obsidian, 第二大脑, 知识管理, AI编程, AIAgent, 效率工具]
timestamp: 2026-07-13T00:00:00Z
---

# 如何给Claude Fable 5搭一个第二大脑

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/6a48812d000000002200b7ff?xsec_token=ABYufUkcegbSYNldP6e2XsOstNowYxSQ5VRNb3Z6prckM=&xsec_source=pc_board
- **作者**: 奥森木
- **日期**: Jul 3 上海
- **标签**: #Claude #ClaudeCode #Obsidian #第二大脑 #知识管理 #AI编程 #AIAgent #效率工具 #人工智能 #大模型

## 正文

最聪明的模型整天产出平庸活，原因只有一个——它不了解你的业务、受众和历史决策，只能猜，猜出来全是模板味。接上你自己的知识库，同一个模型立刻换档：会计场景不带客户历史约 70% 准确率，喂进交易历史后 85% 起步、爬过 90%；配好声音档案的中档模型，比裸跑的 Fable 5 更有辨识度。Anthropic 自测里，文件记忆让 Fable 打卡牌构筑游戏的进步幅度达到前代旗舰的 3 倍（单局、厂商自测、尚无人复现）。
	
为什么选 Obsidian：它就是一个 markdown 文件夹上的漂亮窗口，只用两个功能——wikilinks 双括号连接和图谱视图。vault 就是文件夹，Fable 通过 Claude Code 直接读写，无插件无连接器。
	
结构只要四件套：raw/ 存原始素材（只读，agent 永不改写）、entities/ 一物一页、concepts/ 一念一页、INDEX.md 做前门。四条写作规则：一课一文件、更新不新建、删掉被证伪的、raw 与编译页永远分开。链接是关键：搜索型知识库越大越吵，链接型 wiki 越大越强——karpathy 自己的 vault 约 100 篇文章 40 万字，全由模型编译。
	
回填用 /goal：先把旧聊天记录、书签、笔记导出全倒进 raw/，让模型自己跑、小模型当裁判；改动必须以 diff 交付，无溯源的页面不信任。保活靠四个循环：会话结束 hook 自动记决策、每夜便宜模型编译、每周 lint 查矛盾死链、每周一次大模型综合——只有最后一环值得高档模型。每周再跑一轮研究机器：拆子问题、并行搜索、每个发现开收据、怀疑者 agent 攻击、幸存者带过期日期落库。
	
读取要便宜：CLAUDE.md 控制在 200 行内、只指向 vault；大问题派 subagent 读 50 页带一段结论回来。最后给每个项目的 CLAUDE.md 加三行接入。模型还会换代，vault 熬过每一次换代。最小版本只要一小时。
	
#Claude  #ClaudeCode  #Obsidian  #第二大脑  #知识管理  #AI编程  #AIAgent  #效率工具  #人工智能  #大模型

## 图片(10)

- https://sns-web-i10.rednotecdn.com/202607131513/d2035087f1ef49e96ecf20677830f951/spectrum/1040g0k03226fulcu704g5pjdpov3cmhnv3pehlg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/700a190d2a5d5345b5fc603982ab83f9/spectrum/1040g0k03226fulcu70005pjdpov3cmhn0lgs498!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/694d4c82cc109efa8717745e276d486b/spectrum/1040g0k03226fulcu700g5pjdpov3cmhn493j1n0!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/c02c179d69d1698a68f1dda0fd5c4cf2/spectrum/1040g0k03226fulcu70105pjdpov3cmhn13khqd8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/681e11038c10341d651e78de7012f9cb/spectrum/1040g0k03226fulcu701g5pjdpov3cmhnok50rho!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/f8936ca8557051cc102b23846cd80c0f/spectrum/1040g0k03226fulcu70205pjdpov3cmhnnqjtui0!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/5de16b5a79c37c5c3f9d553db12ed48e/spectrum/1040g0k03226fulcu702g5pjdpov3cmhntd95eq8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/c6d0051e0b1f8296ba45618d43de1ea1/spectrum/1040g0k03226fulcu70305pjdpov3cmhnl0itfho!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/741488fdc7b79567c7d50da5edec60b9/spectrum/1040g0k03226fulcu703g5pjdpov3cmhnv71hbm0!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131513/b6e6cf80611c60150fb3082cc988b3ac/spectrum/1040g0k03226fulcu70405pjdpov3cmhno0ndlj0!nd_dft_wlteh_webp_3?src=A

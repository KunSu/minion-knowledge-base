---
type: raw
id: 699afc6a0000000015023124
title: "用discord论坛标签自动管理openclaw任务"
description: "小红书 openclaw 收藏夹笔记原文:用discord论坛标签自动管理openclaw任务"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/699afc6a0000000015023124?xsec_token=ABW9Ay5NJQTEBw18u3K2IRYVg3yjIhWfu2_f1983BM7yY=&xsec_source=pc_board
tags: [rednote, openclaw]
timestamp: 2026-07-13T00:00:00Z
---

# 用discord论坛标签自动管理openclaw任务

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/699afc6a0000000015023124?xsec_token=ABW9Ay5NJQTEBw18u3K2IRYVg3yjIhWfu2_f1983BM7yY=&xsec_source=pc_board
- **作者**: 杨卫薪律师
- **日期**: Feb 22

## 正文

昨天发了个帖子讲如何用标签管理openclaw的任务，但这个标签还是得人去主动进行添加的
	
后面我发现 discord 的 API 允许 Agent 去发帖和修改标签
诶我灵机一动
如果这样，那么就…
	
标签本身就可以作为管理 AI 任务的工具，于是我写了个discord-task-center 的skill，现在能实现的功能如下：
	
1.通过标签显示当前使用的模型，并且如果修改了模型标签，在下次对话的时候，openclaw 会切换成对应的模型进行对话
	
2.跟 Agent 说归档任务的时候，也会把修改标签为归档，这样就可以动态筛选了
	
3.跟 Agent 说新建一个任务的时候，openclaw 会新建一个帖子，打上对应的任务状态和模型标签，进行新任务的自动推进
	
多agent协作正在更新中，后面会把这个skill更新到clawhub和github
	
另：图里面客户紧急要求下午5点前完成合同审查是幻觉信息

## 图片(2)

- https://sns-web-i10.rednotecdn.com/202607131554/1ede7070183d47267386e98b0952fab2/1040g2sg31st0t75vlse0421oh7nlqntq757etg8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131554/9a1e91af88acf8d8337b30e17af87aa9/1040g2sg31st0t75vlseg421oh7nlqntqki28a6g!nd_dft_wlteh_webp_3?src=A

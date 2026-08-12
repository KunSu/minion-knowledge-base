---
type: raw
id: 699f0e75000000002603f184
title: "Reminder"
description: "小红书 openclaw 收藏夹笔记原文:Reminder"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/699f0e75000000002603f184?xsec_token=AByofGd6dmN_5gxUdknevYuE-yZDA_FOjS3koJGcizSxI=&xsec_source=pc_board
tags: [rednote, openclaw, openclaw, 大模型, vibecoding大赏, 智能体, AI工具]
timestamp: 2026-07-13T00:00:00Z
---

# Reminder

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/699f0e75000000002603f184?xsec_token=AByofGd6dmN_5gxUdknevYuE-yZDA_FOjS3koJGcizSxI=&xsec_source=pc_board
- **作者**: 白衣
- **日期**: Edited at Feb 25
- **标签**: #openclaw #大模型 #vibecoding大赏 #智能体 #AI工具

## 正文

用openclaw做multi-agent的小伙伴们注意啦
	
不知道你有没有发现，openclaw因为并不是原生一开始就支持多agent而是后来补上的能力，所以一些能力的支持上是有瑕疵的。
	
之前的文章已经分享过多租户的一些坑了，今天再分享一个，相信用得溜的小伙伴已经碰到过了：
	
你有发现没，你的cron定时任务，在multi agent的模式下，只有一个agent的私聊是可以正常接收cron定时消息的，其他agent聊天定时任务经常不灵！ 是不是遭透了心
	
原因在于🦞的代码实现里除非你的agent显示声明heartbeat，否则默认只生效default的那个！！！无论你的default里是不是设置了heartbeat配置！
	
是不是够隐晦的… 下面的配置拿好啦
	
"defaults": {
"heartbeat": { "every": "30m" }  // ← 默认启用
},
"list": [
{ "id": "main", "heartbeat": { "every": "30m" } },
{ "id": "midori", "heartbeat": { "every": "30m" } },
{ "id": "hana", "heartbeat": { "every": "30m" } }
]
	
关注我，每天带给你一个意想不到的AI新发现！
	
#openclaw #大模型 #vibecoding大赏 #智能体 #AI工具

## 图片(1)

- https://sns-web-i10.rednotecdn.com/202607131555/780800ca3c75d656c2374a60b8081548/notes_pre_post/1040g3k031t10fg8r5a005n9pjhm4nb1dv5j3png!nd_dft_wlteh_webp_3?src=A

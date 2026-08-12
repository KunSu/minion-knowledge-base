---
type: raw
id: 69af81ef0000000015030d8b
title: "吴恩达出手，3行命令提升AI编程准确率"
description: "小红书 openclaw 收藏夹笔记原文:吴恩达出手，3行命令提升AI编程准确率"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69af81ef0000000015030d8b?xsec_token=AB1T5XB8zKU8cwxupAnN1vErYS1sYUU6AthvMXQQf_0mg=&xsec_source=pc_board
tags: [rednote, openclaw]
timestamp: 2026-07-13T00:00:00Z
---

# 吴恩达出手，3行命令提升AI编程准确率

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/69af81ef0000000015030d8b?xsec_token=AB1T5XB8zKU8cwxupAnN1vErYS1sYUU6AthvMXQQf_0mg=&xsec_source=pc_board
- **作者**: 量子位
- **日期**: Edited at Mar 9

## 正文

众所周知，AI智能体写代码时经常出错，比如它会发明不存在的参数，或者调用早已过时的接口。
	
这是因为AI的学习数据停留在过去，无法实时掌握最新的API文档变化。
	
而吴恩达发布了Context Hub工具，专门解决这个问题。
	
它可以让Agent写代码之前，先拉取最新文档，读完再动手写。
	
这就像是给AI配了一个实时更新的百科全书，即便API文档昨天刚更新，AI也能瞬间同步。
	
用起来也很简单，只需记住下面这三行：
	
npm install -g @aisuite/chub
chub search openai # 搜可用文档
chub get openai/chat # 拉取最新文档
	
目前这个工具已经开源，对于经常使用Claude Code等各类Agent编程的人来说，Context Hub能显著降低代码出错的概率。
	
👉：andrewyng/context-hub

## 图片(2)

- https://sns-web-i10.rednotecdn.com/202607131553/b4ed0c885c9eddf3efe36db3535f707f/spectrum/1040g34o31th382qtle105oh8gs5413k8tftlhtg!nd_dft_wgth_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131553/124cfbd49317997de3e4d268c7e324d5/spectrum/1040g34o31th2qef5le105oh8gs5413k83umbp7o!nd_dft_wlteh_webp_3?src=A

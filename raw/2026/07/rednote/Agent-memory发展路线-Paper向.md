---
type: raw
id: 69a74440000000001a02bfc2
title: "Agent memory发展路线（Paper向）"
description: "小红书 openclaw 收藏夹笔记原文:Agent memory发展路线（Paper向）"
resource: https://www.rednote.com/board/698ed28d0000000025034bea/69a74440000000001a02bfc2?xsec_token=ABgC05TlB4lvVFWZQ_quaz_32aA5rAv72eF86Fik2T8yI=&xsec_source=pc_board
tags: [rednote, openclaw, Agent, Memory, LLM, AI记忆]
timestamp: 2026-07-13T00:00:00Z
---

# Agent memory发展路线（Paper向）

- **来源 board**: openclaw (https://www.rednote.com/board/698ed28d0000000025034bea)
- **URL**: https://www.rednote.com/board/698ed28d0000000025034bea/69a74440000000001a02bfc2?xsec_token=ABgC05TlB4lvVFWZQ_quaz_32aA5rAv72eF86Fik2T8yI=&xsec_source=pc_board
- **作者**: AgenSea
- **日期**: Mar 3
- **标签**: #Agent #Memory #LLM #AI记忆

## 正文

Mem0  工程化 Memory 基建。通过维护动态 Memory Graph，实现跨对话实体整合与状态更新，强调生产级可落地性。
A-Mem (Agentic Memory) 动态语义网络式记忆组织。LLM 主动生成标签与语义链接，使记忆结构随时间演化。
Memory-R1 (Yan et al., 2025) 强化学习驱动的双智能体框架。通过显式记忆动作（ADD / UPDATE / DELETE / NOOP）与记忆蒸馏机制，实现可学习的记忆管理策略，在极小数据规模下显著提升长程推理能力。
MEM1 (2025) 内生状态式记忆模型。通过压缩循环状态替代追加式上下文堆叠，实现恒定内存占用的长程交互能力。
ReMemR1 (2025) 引入回溯机制与多级奖励信号，缓解递归状态压缩带来的信息不可逆丢失问题。
Mem-α (2026) 分层记忆架构（Core / Semantic / Episodic）与显式记忆操作策略优化，实现高度自治的记忆管理系统。
#Agent #Memory #LLM #AI记忆

## 图片(10)

- https://sns-web-i10.rednotecdn.com/202607131552/91a7c8d90b433df0f79565f515002da1/spectrum/1040g0k031t919280me4g5p9p1vi38pfultm3uro!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/5f82f54b598190b80b55c4b98feff437/spectrum/1040g0k031t919280me005p9p1vi38pfuf0qg630!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/7356e5b0687b08c7a0f9db15385f90c4/spectrum/1040g0k031t919280me0g5p9p1vi38pfurrppe28!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/f8894c09aad3b8ec5e1f6daf5a0fbd95/spectrum/1040g0k031t919280me105p9p1vi38pfu48s919g!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/2041dc16e065e87288880bdfe542ba7d/spectrum/1040g0k031t919280me1g5p9p1vi38pfus02lkvg!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/4b331c2984c090d7e6c685016b576194/spectrum/1040g0k031t919280me205p9p1vi38pfumuf1738!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/fa14eceb8ed482decf08977bbc3dc44a/spectrum/1040g0k031t919280me2g5p9p1vi38pfucb9hho8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/f18893fe07818daacbd1b7c0f4b35fcf/spectrum/1040g0k031t919280me305p9p1vi38pfun07m9h8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/e7b2cef3181fc1e2991179504ac338cd/spectrum/1040g0k031t919280me3g5p9p1vi38pfu51edns8!nd_dft_wlteh_webp_3?src=A
- https://sns-web-i10.rednotecdn.com/202607131552/e5315a153d36da57ceb4d7fedb616a5e/spectrum/1040g0k031t919280me405p9p1vi38pfucckku3o!nd_dft_wlteh_webp_3?src=A

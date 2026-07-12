---
type: convention
title: Amazon 工作规范
description: Amazon 内部工作时的生产安全铁律、构建系统入口与包容性语言约定(amazon scope,与个人 convention 分开)
scope: amazon
tags: [amazon, aws, brazil, production-safety]
timestamp: 2026-07-11T00:00:00Z
---

# Amazon 工作规范

> **`scope: amazon`——仅干 Amazon 相关活时才加载本页**(AWS 资源、Brazil workspace、内部系统)。做个人项目时**不必读**,以省 context。与 Owner 的个人 convention 分开:个人开发遵个人规范(见 [agent-orchestration](agent-orchestration.md) 等),Amazon 开发遵本页。内容为业界/公司公开标准。通用工程偏好见 [engineering](../preferences/engineering.md)。

## 生产安全铁律(操作 AWS / 生产资源时强制)

- **最小权限优先**:凡不需要写权限的操作,用 ReadOnly / 最小权限凭证,而非 Admin。
- **生产资源不擅自删除**:未经 Owner 明确指示,禁止删除生产环境资源(可能导致服务中断或数据丢失)。
- **不确定即当生产**:无法判断资源/凭证是否属于生产时,一律按生产对待、最大程度谨慎。
- **非破坏操作优先**:能 read/describe/list 就不 modify/update/delete。
- **破坏性操作先确认**:生产环境的 delete/terminate/modify 动手前必须获 Owner 明确确认,并讲清影响。
- **不擅自关安全保护**:termination protection、deletion protection、MFA delete、versioning、备份保留策略等,未经 Owner 确认 + 明确理由,不得关闭。
- **识别生产**:凭证看 `~/.aws/config` profile 名(ReadOnly/Admin/Prod/Beta)、`aws sts get-caller-identity` 的 role ARN、`aws iam list-attached-role-policies`(含 AdministratorAccess/FullAccess 要格外小心);资源看名字/tag 是否含 `prod`/`production`/`prd`,以及是否缺少 `dev`/`test`/`beta`/`staging`/`sandbox` 标识。

## 内部系统入口

文档总入口:Amazon Software Builder Experience(ASBX)docs — https://docs.hub.amazon.dev/

- **Brazil** — 代码管理与构建系统(编译、版本、依赖、可复现构建、artifact)。workspace 结构:根含 `src/`,每个 package 是独立 git repo;必须 `cd src/<PackageName>` 后再构建,不能在 workspace 根构建。构建先看 package README;标准构建 `brazil-build release`,输出量大务必重定向到临时文件再 grep/tail。多包用 `brazil-recursive-cmd`。缺依赖先 `brazil workspace merge`。
- **CRUX** — 代码评审(类似 GitHub PR),`cr` 命令创建,Code Browser 内评审。
- **Coral** — AWS 服务框架(RPC/REST 服务的默认选择)。
- **Apollo** — 内部部署服务(部署到主机/容器/EC2/Lambda)。
- **Pipelines** — 持续部署(建模、可视化、自动化发布流程;有 Web/API/CLI/CDK)。
- **Taskei** — 任务与项目管理(sprint、kanban、工作流)。
- **BuilderHub** — 建包/建应用/建 Cloud Desktop 的门户。
- **AWS CX Builder Hub** — https://hub.cx.aws.dev/ ,AWSCX 团队专用门户。
- 任何含 `amazon` 的 hostname、以及 `a2z.com` / `aws.dev` 域名 → 用 `ReadInternalWebsites`(需 Midway 认证),不要用普通 web fetch。

## 包容性语言(代码/注释/文档强制)

避免非包容术语:

| 不用 | 改用 |
|---|---|
| master | primary, main, leader, controller |
| slave | replica, secondary, follower, responder |
| whitelist | allowlist, approved list, inclusion list |
| blacklist | denylist, blocklist, exclusion list |
| whiteday(s) | clear day(s), allowed day(s) |
| blackday(s) | blocked day(s) |

---
type: convention
title: Amazon 工作规范
description: Amazon 内部工作时的生产安全铁律、构建系统入口、Cloud Desktop(cdd)endpoint 路由与包容性语言约定(amazon scope,与个人 convention 分开)
scope: amazon
tags: [amazon, aws, brazil, production-safety, cloud-desktop]
timestamp: 2026-09-21T00:00:00Z
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

## Cloud Desktop(`cdd`)endpoint 路由

`cdd` 是 Owner 自写的工具(`~/.local/bin/cdd`,不入库),从 Mac 通过 SSH + tmux 流式驱动远端 Cloud Desktop。**要在 Cloud Desktop 上做事一律用 `cdd`,不要裸 `ssh`**——裸 ssh 拿不到工具链 PATH,也落不到正确工作目录。

它有两个 endpoint,**不对等**:

| endpoint | ssh 别名 | 什么时候用 |
|---|---|---|
| **main** | `Host cdd` | **默认。** Owner 说「在 cdd 上跑 X」一律走这台,不加任何 flag |
| **adhoc** | `Host cdd-adhoc` | **只有 Owner 在那句话里明确提到「adhoc」时**才用 |

```bash
cdd <子命令>                  # main(默认)
cdd --adhoc <子命令>          # adhoc,仅此一条
cdd -e adhoc <子命令>         # 同上(--endpoint 等价)
CDD_ENDPOINT=adhoc cdd ...    # 整个 shell / 一串命令都走 adhoc
cdd --main <子命令>           # 上一条已生效时,临时切回 main
```

**flag 必须放在子命令前面**:`cdd --adhoc ls` 对,`cdd ls --adhoc` 错(后者会报错,不会静默去列 main)。

**为什么必须显式点名、且脚本刻意不做「自动挑一台活着的」**:两台机器上的 tmux session **同名**(都是 `cc-$CLAUDE_CODE_SESSION_ID`),各有独立的 `~/cdd-logs/` 和独立的 Midway cookie。走错机器时 `cdd tail` / `peek` / `kill` 会**静默**指向另一台的另一个任务——不报错,只是答案是错的,属最难查的一类错。宁可报错也不猜。

**操作纪律**:一个任务在哪台起的,后续 `tail` / `peek` / `kill` 就必须带同一个 flag,别中途换。不确定自己在哪台,看每条命令开头往 stderr 打的 `cdd[endpoint → 别名]` 前缀,或 `cdd ls` / `cdd --adhoc ls` 各看一眼。`cdd doctor` 查的是**当前 endpoint** 的连通性与 Midway 时钟,换台要重新查。

换机器只改 `~/.ssh/config` 里对应那个 `Host` 块的 HostName,脚本不动。**主机名只存在于 `~/.ssh/config`**——本 repo 是 public,脚本和本页都不写主机名,这是它能被公开讨论的前提。完整用法 `cdd help`;本机文档在 `tools/cdd/`(已 gitignore)。

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

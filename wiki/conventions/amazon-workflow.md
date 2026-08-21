---
type: convention
title: Amazon 工作规范
description: Amazon 内部工作时的生产安全铁律、构建系统入口与包容性语言约定(amazon scope,与个人 convention 分开)
scope: amazon
tags: [amazon, aws, brazil, production-safety]
timestamp: 2026-08-19T00:00:00Z
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

## Bedrock 上的编排环境(Midway / 429 / prompt cache)

> 2026-08-19 从 [多模型编排规范](agent-orchestration.md) 搬来。那页是 `scope: personal` 且每次派子代理都会加载,这些 Amazon 专属细节留在那里等于个人项目也照单加载。编排本身的规则(角色→模型映射、硬边界)仍在那页。

**401 / 403 / "security token expired" / "Could not load credentials" 通常是 Midway 过期**,不是 OAuth 问题——`/login` 在 3P provider 模式下不可用,跑 `mwinit -o` 重试。Midway cookie 有效期约 2 小时。**`mwinit` 刷了还报 401 就是凭证链走错 profile**(见 [agent-orchestration](agent-orchestration.md)「静默失败陷阱」#3)。这两条成因对 Claude Code 和 Codex 都适用,不是 Codex 专有。

429 在 Bedrock 上分两种,对应**两个独立令牌桶**(按 `账号 × region × 模型` 维护,独立检查):`Too many requests`(RPM,与请求大小无关)和 `Too many tokens`(TPM)。**实测近 8 天 12 次真实 429 里 11 次是 RPM**——所以请求大小不是主因,`[1m]` 也不是触发器。

**实测发现 429 与自身负载反相关**:12 次全部落在 09:47–15:11 PDT,而该时段吞吐比零事故的深夜时段**轻 7–10 倍**,6/12 次发生在「前 60 秒一个请求都没发」时。强推断是共享配额在太平洋工作时段被其他租户争用(账号是否多租户共享未直接核验)。**最强杠杆是把重活挪出 09:00–15:00 PDT**,配置只能做优雅降级(降级手段见编排页的模型分池两条)。

**prompt cache 的真实成本来自 5 分钟 TTL 到期**:Claude Code 只用 5 分钟档(`ephemeral_1h = 0`)。按距同 session 上一请求的间隔分组,5 分钟处是干净阶跃——间隔 >5min 的请求平均 cache_creation 从 4k 跳到 187k(>30min 则 352k)。**3% 的请求制造了约 30% 的缓存写入量**:多 session 轮转时每个 session 空转超 5 分钟就 TTL 到期,下一轮按 1.25× 重写整个约 35 万 token 前缀。

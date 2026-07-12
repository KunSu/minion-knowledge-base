---
name: awake
description: Keep the Mac awake for N hours using macOS-native caffeinate. Use when the owner types "@awake <hours>" (e.g. "@awake 4") to prevent sleep, or "@awake --disable" to stop.
---

# awake — 让 Mac 保持唤醒

## 触发

- `@awake <hours>`(如 `@awake 4`)→ 保持唤醒 N 小时
- `@awake --disable` → 停止

## 行为

**权威脚本 = 本目录下的 `keep_awake.sh`**(随 KB 走,repo clone 到哪它就在哪)。在后台运行**本 SKILL.md 同目录**的脚本(务必 `run_in_background: true`):

```bash
bash "$(dirname 本SKILL.md)"/keep_awake.sh <hours>   # 保持唤醒
bash "$(dirname 本SKILL.md)"/keep_awake.sh --disable # 停止
# 即:<KB repo>/skills/awake/keep_awake.sh —— 用 KB 在本机的实际 clone 路径
```

> 多机说明:脚本随 KB repo 走,找它就到本机的 `<KB>/skills/awake/keep_awake.sh`。本机若另有 `~/Documents/Code/Agent/keep_awake.sh`(全局 `@awake` rule 的默认路径),那是指向本机 KB 的 symlink——换机不保证存在,以本 skill 目录下的脚本为准。

运行后简短确认将保持多久 / 已停止。

## 为什么用 caffeinate(硬性,勿改回)

早期版本用 `osascript ... key code 63` 每 240s 模拟一次 fn 键——**无效**:合成键事件不会重置 macOS 的 HID idle timer,且 240s 已超过 `pmset sleep 1`(1 分钟)阈值,系统照睡。用 `caffeinate -dimu` 才会注册真正的 `PreventUserIdleSystemSleep` / `PreventUserIdleDisplaySleep` assertion(可用 `pmset -g assertions` 核实)。

标志:`-d` 显示、`-i` 系统 idle、`-m` 磁盘、`-u` 用户活跃。**故意不加 `-s`**——`-s` 只在接电源时生效,`-dim` 电池下也覆盖。

#!/usr/bin/env bash
# init.sh — 把 minion-knowledge-base 的 base 配置分发到 ~/.claude,使其全局生效
#
# 设计:
#   - 逐文件 symlink(不是 cp)→ 改任一边都是改源,结构上不可能漂移
#   - 幂等:重复跑不出错;已是正确 symlink 就跳过
#   - 安全:遇到已存在的实体文件先备份再链,不静默覆盖
#   - 任意环境:不硬编码用户名/路径,从脚本位置推导 repo 根
#
# 不碰的东西(有意为之):
#   - ~/.claude/settings.json      机器特定(含 awsCredentialExport 等本地路径)
#   - ~/.claude/rules/amazon-*     公司下发,可能被其工具维护
#   - ~/.claude/commands/worklog*  Amazon 工作专用,不进个人 repo
#
# 用法:  bash scripts/init.sh          正常安装
#        bash scripts/init.sh --dry-run 只看会做什么,不动手

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/init-$(date +%Y%m%d-%H%M%S)"
MP_SKILLS_DIR="$HOME/.agents/skills"

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

n_linked=0 n_skipped=0 n_backed_up=0

say()  { printf '%s\n' "$*"; }
run()  { if $DRY_RUN; then say "    [dry-run] $*"; else eval "$@"; fi; }

# link_file <源(相对REPO_DIR)> <目标绝对路径>
link_file() {
  local src="$REPO_DIR/$1" dest="$2" name="${1}"

  if [[ ! -e "$src" ]]; then
    say "  ⚠ 跳过 $name — 源不存在"
    return 0
  fi

  # 已是指向正确源的 symlink → 幂等跳过
  if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
    say "  ✓ $name(已链接)"
    n_skipped=$((n_skipped + 1))
    return 0
  fi

  # 目标已存在:实体文件要备份;旧的错误 symlink 直接替换
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      say "  ↻ $name(重链:旧指向 $(readlink "$dest"))"
      run "rm -f '$dest'"
    else
      # 备份路径按【目标】的相对结构命名(如 commands/brain.md),不用源路径
      local rel="${dest#$CLAUDE_DIR/}"
      say "  ⚑ $name(备份原文件 → ${BACKUP_DIR#$HOME/}/$rel)"
      run "mkdir -p '$BACKUP_DIR/$(dirname "$rel")'"
      run "mv '$dest' '$BACKUP_DIR/$rel'"
      n_backed_up=$((n_backed_up + 1))
    fi
  else
    say "  + $name"
  fi

  run "mkdir -p '$(dirname "$dest")'"
  run "ln -s '$src' '$dest'"
  n_linked=$((n_linked + 1))
}

say "==> minion-knowledge-base → ~/.claude"
say "    源:  $REPO_DIR"
say "    目标:$CLAUDE_DIR"
$DRY_RUN && say "    模式:DRY RUN(不会实际修改)"
say

# ---- 1. 全局 CLAUDE.md ----
say "[1/4] 全局偏好 CLAUDE.md"
link_file "base/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
say

# ---- 2. commands ----
say "[2/4] 斜杠命令 commands/"
if [[ -d "$REPO_DIR/base/commands" ]]; then
  for f in "$REPO_DIR/base/commands"/*.md; do
    [[ -e "$f" ]] || continue
    link_file "base/commands/$(basename "$f")" "$CLAUDE_DIR/commands/$(basename "$f")"
  done
fi
say

# ---- 3. KB skills ----
say "[3/4] KB skills(kb-* + awake)"
if [[ -d "$REPO_DIR/skills" ]]; then
  for d in "$REPO_DIR/skills"/*/; do
    [[ -d "$d" ]] || continue
    name="$(basename "$d")"
    [[ -f "$d/SKILL.md" ]] || { say "  ⚠ 跳过 $name — 无 SKILL.md"; continue; }
    link_file "skills/$name" "$CLAUDE_DIR/skills/$name"
  done
fi
say

# ---- 4. mattpocock skills:外部依赖,只检查不搬运 ----
say "[4/4] mattpocock skills(外部依赖)"
if [[ -d "$MP_SKILLS_DIR" ]]; then
  count=$(find "$MP_SKILLS_DIR" -maxdepth 2 -name SKILL.md 2>/dev/null | wc -l | tr -d ' ')
  say "  ✓ 已安装($count 个,位于 ${MP_SKILLS_DIR#$HOME/})"
  # 确保它们在 ~/.claude/skills 里有发现入口
  missing=0
  for d in "$MP_SKILLS_DIR"/*/; do
    [[ -d "$d" ]] || continue
    name="$(basename "$d")"
    [[ -e "$CLAUDE_DIR/skills/$name" ]] || missing=$((missing + 1))
  done
  if [[ $missing -gt 0 ]]; then
    say "  ⚠ 有 $missing 个未在 ~/.claude/skills 暴露 —— 跑 mattpocock 自己的安装器补齐"
  fi
else
  say "  ✗ 未安装。开发以 mattpocock skills 为主,必须装上:"
  say "      git clone https://github.com/mattpocock/skills"
  say "      然后按其 README 安装(会装到 ~/.agents/skills 并 symlink 到 ~/.claude/skills)"
fi
say

say "==> 完成:$n_linked 个链接,$n_skipped 个已存在,$n_backed_up 个原文件已备份"
[[ $n_backed_up -gt 0 ]] && say "    备份位置:$BACKUP_DIR"
$DRY_RUN && say "    (dry-run:未实际修改任何东西)"
say
say "    验证:ls -la ~/.claude/CLAUDE.md ~/.claude/commands/"
say "    Claude Code 里跑 /help 或 /brain 确认命令可用"

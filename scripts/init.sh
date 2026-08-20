#!/usr/bin/env bash
# init.sh — 把 minion-knowledge-base 的 base 配置分发到 ~/.claude 与 ~/.codex,使其全局生效
#
# 设计:
#   - 逐文件 symlink(不是 cp)→ 改任一边都是改源,结构上不可能漂移
#   - 幂等:重复跑不出错;已是正确 symlink 就跳过
#   - 安全:遇到已存在的实体文件先备份再链,不静默覆盖
#   - 任意环境:不硬编码用户名/路径,从脚本位置推导 repo 根
#
# 不碰的东西(有意为之):
#   - ~/.claude/settings.json      机器特定(含 awsCredentialExport 等本地路径)
#   - ~/.codex/config.toml         机器特定(含 AWS region、project trust_level)
#   - ~/.claude/rules/amazon-*     公司下发,可能被其工具维护
#   - ~/.claude/commands/worklog*  Amazon 工作专用,不进个人 repo
#
# 用法:  bash scripts/init.sh          正常安装
#        bash scripts/init.sh --dry-run 只看会做什么,不动手

set -euo pipefail

# BASH_SOURCE 兜空 + repo 断言:管道执行时它未定义(set -u 会杀脚本),
# 经 symlink 调用时 dirname 又算不出真实 repo 根。两种情况都显式报错退出,
# 而不是算出 REPO_DIR=/ 然后静默「跳过所有文件」。
SELF="${BASH_SOURCE[0]:-}"
if [[ -z "$SELF" ]]; then
  printf '%s\n' "✗ 请以文件方式执行(bash scripts/init.sh),不要管道执行——管道下无法定位 repo 根" >&2
  exit 1
fi
REPO_DIR="$(cd "$(dirname "$SELF")/.." && pwd)"
# 断言 repo 真在那儿:dirname 不穿透 symlink,经 symlink 调用时上面会算出错误的 REPO_DIR,
# 那会让每个 link 都静默报「源不存在」并以 0 退出——比直接失败更危险。
if [[ ! -f "$REPO_DIR/base/CLAUDE.md" ]]; then
  printf '%s\n' "✗ 未能定位 repo 根(算出 $REPO_DIR)。请直接执行仓库内的真实路径,不要经 symlink 调用" >&2
  exit 1
fi
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
CODEX_DIR="${CODEX_DIR%/}"   # 去掉尾斜杠,否则下面的前缀匹配会失配
BACKUP_DIR="$CLAUDE_DIR/backups/init-$(date +%Y%m%d-%H%M%S)"
MP_SKILLS_DIR="$HOME/.agents/skills"

DRY_RUN=false
case "${1:-}" in
  "")         ;;
  --dry-run)  DRY_RUN=true ;;
  *)          printf '%s\n' "✗ 未知参数:$1(只支持 --dry-run)。拼错的参数不应被当作正常安装" >&2; exit 1 ;;
esac

n_linked=0 n_skipped=0 n_backed_up=0
# 总步数从本文件里 next_step 的调用次数自动数出来,不手维护(加/删一节自动跟上)
N_STEPS=$(grep -c '^next_step ' "$SELF" || true)
step=0

say()  { printf '%s\n' "$*"; }
# run 接受 argv(不是拼接的字符串):含空格或单引号的路径也安全,不走 eval
run()  { if $DRY_RUN; then say "    [dry-run] $*"; else "$@"; fi; }
# 步骤计数器:加/删一节只改 N_STEPS,不用逐处改 [N/6]
next_step() {
  step=$((step + 1))
  if [[ "$N_STEPS" -gt 0 ]]; then say "[$step/$N_STEPS] $*"; else say "[$step] $*"; fi
}

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
      run rm -f "$dest"
    else
      # 备份路径 = <来源根>/<目标相对结构>,如 claude/commands/brain.md、codex/agents/x.toml。
      # 必须带来源前缀:两个根下可能有同名文件(如 AGENTS.md),拍平会互相覆盖。
      local rel
      case "$dest" in
        "$CLAUDE_DIR"/*) rel="claude/${dest#"$CLAUDE_DIR"/}" ;;
        "$CODEX_DIR"/*)  rel="codex/${dest#"$CODEX_DIR"/}"  ;;
        *) say "  ✗ $name — 目标 $dest 不在已知根下,跳过(拒绝拍平路径导致覆盖)"; return 0 ;;
      esac
      say "  ⚑ $name(备份原文件 → ${BACKUP_DIR#"$HOME"/}/$rel)"
      run mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      run mv "$dest" "$BACKUP_DIR/$rel"
      n_backed_up=$((n_backed_up + 1))
    fi
  else
    say "  + $name"
  fi

  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
  n_linked=$((n_linked + 1))
}

# link_dir <源目录(相对REPO_DIR)> <glob> <目标目录绝对路径>
# 把源目录下匹配 glob 的每个条目逐个 link 到目标目录同名位置
link_dir() {
  local srcRel="$1" pattern="$2" destDir="$3"
  if [[ ! -d "$REPO_DIR/$srcRel" ]]; then
    say "  ⚠ 跳过 — $srcRel/ 不存在"
    return 0
  fi
  local f
  for f in "$REPO_DIR/$srcRel"/$pattern; do
    [[ -e "$f" ]] || continue
    link_file "$srcRel/$(basename "$f")" "$destDir/$(basename "$f")"
  done
}

say "==> minion-knowledge-base → ~/.claude + ~/.codex"
say "    源:  $REPO_DIR"
say "    目标:$CLAUDE_DIR(Claude Code)"
say "          $CODEX_DIR(Codex)"
$DRY_RUN && say "    模式:DRY RUN(不会实际修改)"
say

# ---- 1. 全局偏好:孪生文件,各自入口 ----
next_step "全局偏好(Claude CLAUDE.md + Codex AGENTS.md)"
link_file "base/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
link_file "base/AGENTS.md" "$CODEX_DIR/AGENTS.md"
say

# ---- 2. commands ----
next_step "斜杠命令 commands/"
link_dir "base/commands" "*.md" "$CLAUDE_DIR/commands"
say

# ---- 3. KB skills ----
next_step "KB skills(kb-* + awake)"
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
next_step "mattpocock skills(外部依赖)"
if [[ -d "$MP_SKILLS_DIR" ]]; then
  count=$(find "$MP_SKILLS_DIR" -maxdepth 2 -name SKILL.md 2>/dev/null | wc -l | tr -d ' ')
  say "  ✓ 已安装($count 个,位于 ${MP_SKILLS_DIR#"$HOME"/})"
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

# ---- 5. Claude 子代理定义 ----
# 只分发定义,不在 CLAUDE.md 里加无条件引用 —— subagent frontmatter 是声明式的,
# 放着不改变编排行为,只在 description 匹配时才派发。这样与 mattpocock skills
# 自带的编排规则(双轴并行、design-it-twice)不冲突:skill 有自己编排时走 skill 的。
next_step "子代理定义 agents/(Claude)"
link_dir "base/agents" "*.md" "$CLAUDE_DIR/agents"
say

# ---- 6. Codex 子代理定义 ----
next_step "子代理定义 agents/(Codex)"
link_dir "base/codex-agents" "*.toml" "$CODEX_DIR/agents"
say

say "==> 完成:$n_linked 个链接,$n_skipped 个已存在,$n_backed_up 个原文件已备份"
[[ $n_backed_up -gt 0 ]] && say "    备份位置:$BACKUP_DIR"
$DRY_RUN && say "    (dry-run:未实际修改任何东西)"
say
say "    验证:ls -la $CLAUDE_DIR/CLAUDE.md $CLAUDE_DIR/agents/ $CODEX_DIR/AGENTS.md $CODEX_DIR/agents/"
say "    Claude Code 里跑 /help 或 /brain 确认命令可用;/agents 确认子代理已加载"

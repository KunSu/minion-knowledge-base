---
description: Spawn a Sonnet subagent to adversarially review the current code changes
---

对**当前代码变更**做一次对抗式审查。聚焦代码正确性与质量。

## 做法

1. **确定审查范围**(按此优先级):
   - 若 `$ARGUMENTS` 给了文件/目录/范围,审查它。
   - 否则用 git 取未提交变更:`git diff HEAD`(含 staged + unstaged);若为空则 `git diff main...HEAD` 取分支变更。
   - 若都为空,告诉我没有可审查的变更并停止。

2. **spawn 一个 Sonnet subagent**(`Agent` 工具,`model: sonnet`)做审查。给它:变更的 diff、相关文件的完整内容(不要只看 diff 片段,要读上下文)、以及本项目 `CLAUDE.md` 里的规则(若存在)。

3. subagent 以**对抗式**心态审查,重点找:
   - **正确性 bug**:逻辑错误、边界条件、null/空、竞态、off-by-one、错误处理缺失
   - **回归**:是否破坏了现有行为或不变量(尤其项目 `CLAUDE.md` 里的安全不变量)
   - **安全**:注入、越权、敏感数据泄漏(本项目含 PHI 时尤其严格)
   - **可简化 / 复用**:重复逻辑、可抽取、可删代码
   - **测试覆盖**:关键路径是否缺测试

4. **输出格式**——发现按严重度分组,每条包含 `文件:行`、问题、以及**具体修复建议**:

   ```
   ## 🔴 HIGH
   - `path/to/file.py:42` — <问题> → <修复建议>

   ## 🟡 MEDIUM
   - ...

   ## 🟢 LOW
   - ...
   ```

   无发现的档次省略。全部通过则明确说"未发现问题"。

5. **只报告,不改代码**,除非我在 `$ARGUMENTS` 里明确说 apply/fix。

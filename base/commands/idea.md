---
description: 把一个 idea/todo 一句话捕获进 minion-brain 的 Inbox(第二大脑)
---

把 `$ARGUMENTS` 描述的想法捕获进我的第二大脑 **minion-brain**,让它不再散落在对话里。

## 做法

1. 解析 `$ARGUMENTS`:提炼一个简洁的 **title**;若我给了更多上下文,放进 notes。
2. 判断 **type**:灵感/点子 → `idea`;待办 → `todo`;想研究的话题 → `topic`;某项目的功能 → `feature`。拿不准用 `idea`。
3. 判断 **priority**(low/medium/high),拿不准用 `medium`。
4. 若我明确说了要 AI 去做这件事,加 `--queue --prompt "<清晰的任务描述>"`,让它进 AI 任务队列;否则只落 Inbox。
5. 执行(注意 notes 用 `--notes-file` 走临时文件,避免引号/换行问题):

   ```bash
   cd "${MINION_BRAIN_DIR:-$HOME/Documents/Github/minion-brain}" && pnpm minion add \
     --title "<title>" --type <type> --priority <priority> --notes "<notes>"
   ```

6. 回我一行确认:创建的 id、type/status/priority、title。**不要展开讨论**,除非我追问——捕获要快,不打断我手上的事。

> 背景:minion-brain 是我的第二大脑(minion-brain.vercel.app),手机/桌面都能看。这个命令解决"idea 在 AI 对话里冒出来却没地方放"的泄漏。之后我会在 App 或 `minion list` 里回顾。

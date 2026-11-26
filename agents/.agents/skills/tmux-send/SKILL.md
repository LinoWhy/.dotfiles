---
name: tmux-send
description: 向用户指定的本机 tmux pane 粘贴并提交文字。用于在 tmux 中给指定 pane 内的 Agent 发送消息。
---

# 给 tmux pane 发送消息

将用户给出的 pane 目标原样传给 `scripts/send.sh`，例如 `M:3.0` 或 `%160`。正文从标准输入读取，脚本粘贴后按一次 Enter。

```bash
bash "$skill_dir/scripts/send.sh" 'M:3.0' <<'MESSAGE'
第一行消息
第二行消息
MESSAGE
```

`$skill_dir` 是本技能目录。目标 Agent 应处于消息输入界面。多行正文需要接收端支持括号粘贴（bracketed paste），以保留段内换行。

需要确认接收效果时，用 `tmux capture-pane -p -t "$target"` 查看同一 pane 的回显或回复。

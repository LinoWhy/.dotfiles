# Claude Code、Codex 与 Antigravity CLI 配置

## Claude Code

在 `settings.json` 中添加以下 hooks，用终端响铃提示通知：

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "printf '\\a'"
          }
        ]
      }
    ]
  }
}
```

## Codex

在 `config.toml` 中添加以下配置，开启桌面通知：

```toml
[tui]
notifications = true
notification_method = "osc9"
status_line = ["model-with-reasoning", "thread-title", "current-dir", "five-hour-limit", "weekly-limit"]
status_line_use_colors = true
screen_reader_detection_done = true
theme = "catppuccin-macchiato"
alternate_screen = "never"
```

tmux 需设置 `set -g allow-passthrough all`，允许后台窗口透传通知。

## Antigravity CLI

用 Stow 安装 `gemini` 后，在 `agy` 中启用状态栏。

```text
/statusline ~/.gemini/config/agy-statusline.sh
```

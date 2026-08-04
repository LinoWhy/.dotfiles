# Claude Code 与 Codex 配置

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

在 `config.toml` 中添加以下配置：

```toml
notify = ["bash", "-c", "printf '\\a'"]
```

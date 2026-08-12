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

### 终端响铃

在 `config.toml` 中添加以下配置，在 Codex 发出通知时响铃：

```toml
notify = ["bash", "-c", "printf '\\a'"]
```

### Agent Picker 会话名称

`~/.codex/hooks.json` 是 dotfiles 中 hook 配置的软链接。
重启 Codex 后，在 `/hooks` 中手动信任 Agent Picker hook。

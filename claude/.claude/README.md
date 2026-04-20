# Claude Code Configuration

Add the following to `settings.json` hooks for terminal bell notification.

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

Install plugins via `/plugins`.

```
superpowers@claude-plugins-official
document-skills@anthropic-agent-skills
clangd-lsp@claude-plugins-official
```

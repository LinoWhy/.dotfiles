---
name: tool-call-rules
description: Use when preparing Bash or shell-like tool calls. Prefer single-line commands so permission matching does not split embedded newlines into separate commands.
---

# Tool Call Rules

Permission matching treats embedded newlines as command separators, similar to `&&` or `;`. Wildcards also do not span newlines.

## Rules

- Prefer single-line Bash or shell-like tool calls.
- Split multi-step work into separate tool calls instead of one multi-line command.
- Avoid heredocs, here-strings, line continuations, and cross-line wildcards when permission rules matter.
- Use multi-line commands only when they materially improve correctness or safety.

```bash
rg -n 'pattern' path
```

```bash
fd -H -a 'SKILL\.md$' ~/.claude/skills
```

# Global Agent Rules

## COMMUNICATION LANGUAGE

和用户的所有交流内容必须使用 **简体中文** 表达。
代码统一用 **英文**，文档优先用 **中文**。

## TERMINAL ENVIRONMENT

- 优先使用 `rg` 代替 `grep`。
- 优先使用 `fd` 代替 `find`。

## TOOLS USAGE LIMITATION

Claude Code 的权限匹配把换行符视为命令分隔符（等同 `&&`、`;`），
`*` 通配符无法跨越换行。多行命令会导致 allow 规则匹配失败，每次弹出确认。

**规则：所有 Bash 调用必须将命令写成单行，禁止在命令中嵌入换行符。**

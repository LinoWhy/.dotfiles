# Codex — Global Agent Rules

## 1. COMMUNICATION LANGUAGE

和用户的所有交流内容必须使用 **简体中文** 表达。

## 2. 终端环境

- 搜索文本或文件时，优先使用 `rg`、`fd`，仅在缺失或不可用时再退回 `grep`、`find`。

## 3. CODE EDITING RULES

如果任务涉及 **修改代码、生成补丁、调整逻辑或操作仓库文件**，  
必须严格遵循以下规则：

1. **Read First**
   - 修改前阅读并理解相关代码，不得凭空猜测。

2. **Edit > Write**
   - 优先修改现有文件；非必要不要创建新文件。

3. **Simple > Clever**
   - 优先编写简单、直接、可维护的代码，而不是过度优化的抽象或实现。

4. **No Feature**
   - 只解决用户提出的问题，不增加额外功能。

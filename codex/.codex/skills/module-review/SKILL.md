---
name: module-review
description: Produce a comprehensive module-level code review report for a path or subsystem. Use when the user wants architecture, concurrency, memory, kernel, or API review of a module with a fixed markdown template and written output file.
---

# Module Review

对指定模块执行完整代码评审，并按照固定模板写出 Markdown 报告。

## Inputs

从用户输入中解析：

- 模块名称
- 仓库路径或代码路径
- 需求或设计文档路径，可选
- 输出文件名，可选

若未提供输出文件名，默认使用 `<module>_code_review.md`。

## Review Workflow

1. 理解目标模块的职责与边界。
2. 阅读相关实现、需求和设计文档。
3. 按模板逐项检查功能、架构、并发、控制流、变量、类型、内存、错误处理，以及内核或用户态专项。
4. 只对真实发现的问题写详细说明，并按 `P0` 到 `P3` 分类。
5. 将完整报告写入文件。

## Output Constraints

- 严格遵循既定模板，不新增、删减或改序章节。
- 表格结果列只允许填写：`通过`、`未涉及`、或问题说明引用。
- 有问题的项必须在“详细问题说明”里展开。
- 引用代码位置时使用 Markdown 行内代码标记。

## Review Focus

- 功能边界是否清晰
- 架构与依赖是否合理
- 并发模型、锁与上下文约束是否正确
- 内存、错误路径和接口行为是否安全
- 若是 Linux 内核模块，重点检查生命周期、电源管理、中断上下文、DMA、UAPI 等专项

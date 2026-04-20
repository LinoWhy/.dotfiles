---
name: code-review
description: Perform strict repository code review on a commit, patch, PR, or described change. Use when the user asks to review correctness, regression risk, or implementation quality and wants prioritized findings.
---

# Code Review

执行严格的代码评审，优先找出正确性问题、回归风险和缺失验证。

## Review Rules

- 先判断改动整体是否正确、是否存在风险。
- 重点找 bug、行为回退、边界条件遗漏、接口兼容性问题和测试缺口。
- 如果没有发现会导致回退或正确性问题的项，要明确写出来，并说明已检查的风险点。

## Output Format

1. 总体判断：用 1-2 句说明 patch 是否正确或是否存在风险。
2. 问题列表：按优先级从高到低输出。

问题格式保持为：

```text
[P0-P3] 简短标题 — file_path:start_line-end_line
原因、触发条件、影响，以及明确修复建议
```

## Scope Discovery

- 如果用户给的是 commit、PR 或 patch，先定位对应改动。
- 如果用户给的是描述性目标，先收集相关差异和上下文，再开始评审。
- 只在有必要时补充简短摘要，核心内容始终是 findings。

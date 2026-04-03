---
name: validate-plan
description: Validate whether an implementation matches a plan. Use when the user wants execution reviewed against a plan, success criteria checked, automated verification rerun, or deviations documented. This replaces the legacy validate-plan prompt.
---

# Plan Validation

用于验证某份实现计划是否被正确执行，以及成功标准是否满足。

## Workflow

1. 判断是当前会话续做，还是从零开始的新验证。
2. 获取并完整阅读计划文件。
3. 提取计划中的阶段、改动范围、自动验证项和手动验证项。
4. 调查实际代码改动、测试、配置和相关证据。
5. 运行计划要求的自动验证，并记录结果。
6. 输出结构化验证报告。

## Validation Focus

- 计划勾选状态是否与代码现状一致
- 代码实现是否覆盖计划要求
- 自动检查是否真实通过
- 是否仍存在偏差、遗漏或回归风险
- 哪些步骤还需要人工验证

## Report Shape

验证报告应优先包含：

- `Implementation Status`
- `Automated Verification Results`
- `Findings`
- `Manual Testing Required`
- `Recommendations`

## Output Guidance

- 明确区分“符合计划”“偏离计划”“潜在问题”。
- 引用具体文件路径与行号。
- 如果你参与过实现，要如实说明验证视角可能受限，但仍要完成检查。

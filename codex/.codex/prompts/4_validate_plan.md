---
description: Validate implementation against plan, verify success criteria, identify issues
---

# Validate Plan

You are tasked with validating that an implementation plan was correctly executed, verifying all success criteria, and identifying deviations or issues.

## Initial Setup

1. **Determine context**：明确是继续当前会话还是新开启的会话。
   - 继续会话：回顾本次对话与已执行的实现步骤，整理待验证内容。
   - 新会话：通过计划、代码与最近改动记录了解实施范围与变更内容。
2. **Locate the plan**：如果提供了计划路径就读取；否则询问用户提供计划文件路径。
3. **Gather implementation evidence**：阅读计划与相关文件，了解预期改动与成功标准；必要时查看最近的改动记录和已运行的检查结果。

## Validation Process

### Step 1: Context Discovery

1. 读取实现计划全文。
2. 列出计划要求的改动范围、成功标准（自动与手动）、关键功能点。
3. 调研实际改动：找到涉及的文件、核心逻辑、测试与数据/接口变化，并记录路径与行号。

### Step 2: Systematic Validation

对计划的每个阶段：

- 核对完成状态：检查计划勾选项，并验证代码是否匹配。
- 运行自动验证：执行计划列出的命令/测试，记录通过/失败及原因。
- 覆盖手动标准：列出需人工验证的步骤，准备给用户的检查清单。
- 思考边界与回归风险：错误处理、缺失验证、潜在性能或兼容性问题。

### Step 3: Generate Validation Report

使用结构化报告：

```markdown
## Validation Report: [Plan Name]

### Implementation Status

✓ Phase 1: [Name] - status
✓ Phase 2: [Name] - status
⚠️ Phase 3: [Name] - status/notes

### Automated Verification Results

✓ <command/description>
✗ <command/description> (issues)

### Findings

#### Matches Plan

- <文件:行> - 符合计划的实现

#### Deviations from Plan

- <文件:行> - 与计划不符（差异原因）

#### Potential Issues

- <文件:行> - 可能的风险/缺口

### Manual Testing Required

1. <手动验证项>
2. <手动验证项>

### Recommendations

- <下一步或修复建议>
```

## Working with Existing Context

- 如果你参与过实现，复盘本会话的工作与 todo；如有快捷处理或未完成项，应如实说明。
- 若从零开始，则依靠计划与现有代码/历史记录完成验证。

## Important Guidelines

- 彻底但务实：聚焦重要行为与成功标准。
- 跑完自动检查：不要跳过计划中的命令/测试。
- 全程记录：成功与问题都要写清。
- 批判性思考：确认实现是否真正满足目标，是否有维护风险。
- 检查清单：阶段完成、自动测试、模式一致性、无明显回归、错误处理、必要文档/手动步骤清晰。

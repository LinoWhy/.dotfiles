---
name: implement-plan
description: Execute an approved technical plan phase by phase. Use when the user wants a written plan implemented, especially when progress tracking, checkbox updates, and per-phase verification are required. This replaces the legacy implement prompt.
---

# Plan Implementation

按照现有技术计划逐阶段实施，并持续更新计划状态。

## Startup

1. 获取计划文件路径；如果没提供，先向用户询问。
2. 完整阅读计划，检查已完成的勾选项。
3. 完整阅读计划中引用的关键文件、原始需求和相关上下文。
4. 建立 todo 跟踪当前执行进度。

## Execution Rules

- 按阶段推进，不要跳阶段。
- 每个阶段完成后先做自动验证，再决定是否进入下一阶段。
- 在计划文件中同步更新已完成的勾选项。
- 如果用户没有明确要求连续执行多个阶段，默认每完成一个阶段就停下来等待人工验证。

## Phase Completion Message

阶段完成后，应明确告诉用户：

- 已通过的自动验证项
- 需要人工验证的步骤
- 当前是否可以进入下一阶段

## If Plan and Reality Diverge

若发现计划与代码现状不一致，应暂停并清楚说明：

- 计划预期是什么
- 实际发现了什么
- 为什么这个偏差重要
- 需要用户决定的地方

## Constraints

- 不要把“勾选计划”当成目标，真正目标是让方案在当前代码库里正确落地。
- 如果计划已有完成项，默认信任并从第一个未完成项继续，除非现状明显异常。

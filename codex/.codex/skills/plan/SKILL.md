---
name: plan
description: Create a task plan before implementation. Use when the user wants a plan, scope breakdown, action checklist, or an ExecPlan-style execution document instead of immediate coding. This replaces the legacy plan prompt.
---

# Task Plan

用于在实现前先生成计划，不直接执行计划中的改动。

## First Step

先向用户确认以下内容：

1. 任务目标
2. 主要范围，包括做什么和不做什么
3. 是否需要可接棒的 `ExecPlan`
4. 关键约束，例如时间、技术栈、路径或上线要求

如果用户没有特别说明，默认输出简单计划，不使用 `ExecPlan`。

## Plan Modes

### Default Plan

默认输出简洁计划，包含：

- 任务目标与总体方法
- `Scope`
- `Action items`
- `Open questions`

### ExecPlan

只有用户明确要求 `ExecPlan` 时才使用。

此时应：

1. 先完整阅读 `~/.agent/PLANS.md`
2. 明确声明将遵循该规范
3. 生成完整 `ExecPlan`
4. 将内容写入文件
5. 最终只返回文件路径与简要说明

## Constraints

- 不要实现计划里的内容。
- 不要跳过澄清步骤，除非用户已经把目标、范围和约束说清楚。
- 简单计划优先用中文输出；如果用户指定格式，则遵从用户要求。

---
name: ultra-think
description: Perform multi-framework deep analysis for a complex problem or decision. Use when the user wants competing options, assumption testing, adversarial reasoning, long-term tradeoffs, and an actionable recommendation rather than immediate implementation. This replaces the legacy ultra-think prompt.
---

# Deep Analysis

对复杂问题做多框架深度分析，暴露假设、比较竞争方案，并给出可执行建议。

## Start

先识别：

- 核心挑战
- 关键约束
- 隐含假设
- 受影响相关方

如果问题缺少关键上下文，最多提出 3 个有针对性的问题；如果上下文已足够，直接开始。

## Required Coverage

分析必须覆盖：

- 问题框架
- 至少 3 个有意义的竞争方案
- 多视角评估
- 对抗性测试
- 至少一个跨领域类比
- 6 个月、2 年、10 年的二阶效应
- 综合建议
- 置信度与不确定性说明

## Output Shape

优先使用以下结构：

- `问题分析`
- `方案选项`
- `推荐方案`
- `替代视角`

## Output Guidance

- 每个方案都要按自身优点评估，不要只做相对比较。
- 明确展示结论背后的证据或逻辑。
- 数据不足时直接说明缺口，以及什么信息会改变结论。
- 推荐部分必须足够具体，能直接指导下一步行动。

---
name: research
description: Research and document how a codebase currently works without proposing changes. Use when the user asks for architecture walkthroughs, implementation mapping, behavior tracing, or technical documentation of the current system state. This replaces the legacy research prompt.
---

# Codebase Research

用于调研和记录代码库“当前是怎样工作的”，而不是提出改进方案。

## Core Rules

- 只描述当前实现、位置、交互关系和行为。
- 除非用户明确要求，否则不要给优化建议、根因分析或未来方案。
- 代码是第一手事实来源，文档和注释只作为补充。

## Workflow

1. 如果用户提到了具体文件、文档或工单，先完整阅读这些输入。
2. 把研究问题拆成若干可调查的主题，例如模块、调用链、配置入口、数据流或架构边界。
3. 逐项调研相关代码与文档，必要时并行搜集信息。
4. 汇总结论，给出基于证据的说明，并标注具体文件路径和行号。
5. 如果用户需要成文输出，生成结构化研究文档并补全元数据。

## Recommended Document Shape

当需要输出研究文档时，优先包含以下部分：

- 研究问题
- 总结
- 详细发现
- 代码引用
- 架构说明
- 历史上下文
- 开放问题

## Output Guidance

- 回答要具体、可导航，附带精确文件引用。
- 说明组件之间如何连接、数据如何流动、实现约束在哪里。
- 若用户继续追问，追加同一主题的后续研究，并更新文档时间信息。

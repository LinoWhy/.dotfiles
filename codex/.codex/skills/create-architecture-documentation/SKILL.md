---
name: create-architecture-documentation
description: Generate comprehensive architecture documentation for a project or subsystem. Use when the user asks for architecture docs, C4 or arc42 outputs, ADR scaffolding, diagrams, or system design documentation grounded in the existing codebase. This replaces the legacy architecture-documentation prompt.
---

# Architecture Documentation

为项目或子系统生成结构化架构文档，基于现有代码和文档事实展开。

## Discovery

先收集这些信息：

- 根目录配置文件，例如 `*.json`、`*.yaml`、`*.toml`
- 现有文档，例如 `README.md`、`docs/`
- 设计或架构文件，例如 `*architecture*`、`*design*`、`*.puml`
- 部署与容器配置，例如 `docker-compose.yml`、`k8s/`
- API 定义，例如 `openapi`、`swagger`

## Coverage Areas

根据项目实际情况，组织以下内容：

- 系统上下文与边界
- 容器、服务与部署视图
- 组件与模块关系
- 数据架构与数据流
- 安全与合规架构
- 性能、可靠性、可观测性等横切关注点
- ADR 模板或现有决策记录
- 文档自动化与维护方式

## Output Guidance

- 优先选择适合当前项目的框架，例如 C4、arc42、ADR、PlantUML 或 Mermaid。
- 先基于事实记录现状，再在用户需要时补充改进建议。
- 图表、目录结构和文档模板要能直接落盘使用。

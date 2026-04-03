---
name: obsidian-note
description: Build an Obsidian-ready knowledge base for a topic or local code/document scope. Use when the user wants linked markdown notes, MoC pages, atomic notes, or a structured note vault written to disk.
---

# Obsidian Note

围绕一个主题或本地范围生成可直接用于 Obsidian 的卡片笔记集合。

## Required Inputs

在扫描或写入前，先确认：

1. `scope_or_topic`
2. `output_dir`，可选

如果没有提供 `output_dir`，默认使用 `obsidian/<topic-slug>/`。

## Output Rules

- 所有文件只写入一个输出目录，不创建嵌套子目录。
- 创建且只创建一个 MoC 文件：`_MoC-<topic-slug>.md`
- 创建数量合适的原子笔记
- 使用 Obsidian wikilinks `[[...]]`
- 每个笔记都带 YAML frontmatter，至少包含 `topic` 和 `tags`

## Content Rules

- 正文使用简体中文。
- 代码和 ASCII 图中的文字使用英文。
- 内容强调机制、边界和权衡，不写流程化元叙述。
- 非显而易见的结论才加来源映射。
- 生成完成后检查结构、引用和完整性。

## Workflow

1. 询问必要输入并等待回答。
2. 先做高层发现。
3. 给出预检报告，说明理解的主题、发现概况和计划输出目录。
4. 获得用户明确批准后，再做深度分析和文件生成。
5. 写入后尝试格式化 Markdown。

## Formatting

优先执行：

```bash
prettier --write "<output_dir>/**/*.md"
```

失败时可退回：

```bash
npx prettier --write "<output_dir>/**/*.md"
```

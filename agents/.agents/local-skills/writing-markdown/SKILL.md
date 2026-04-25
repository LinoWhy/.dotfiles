---
name: writing-markdown
description: Use when creating, editing, or formatting Markdown documents. Always format Markdown with prettier after writing or changing it. If the document contains ASCII art, box-drawing diagrams, mixed CJK/ASCII aligned text, or the user reports terminal display alignment issues, also apply the alignment rules and validation workflow.
---

# Markdown 文档写作规范

## 三条核心规则

1. **Markdown 写完必须格式化** — 创建或编辑任何 `.md` 文件后都运行 `prettier --write <file.md>`
2. **复杂图用 mermaid** — 流程图、时序图、状态图等用 mermaid 代码块, 不要用 ASCII art 硬画
3. **ASCII art 方框必须对齐** — 如果文档里有方框图或混排对齐文本, 中文字符 2 列, ASCII 字符 1 列, 方框内每行 display width 必须一致

---

## 规则一: Prettier 格式化

创建或编辑 Markdown 后必须执行:

```bash
prettier --write <file.md>
```

要求:

- 对本次新增或修改的 Markdown 文件逐个格式化。
- 如果项目有自己的 Markdown 格式化命令, 优先使用项目命令。
- 如果 `prettier` 或项目格式化命令不可用, 在最终回复里说明没有完成格式化及原因。
- `prettier` 不会改动代码块内部, 所以 ASCII art 对齐仍需单独处理。

---

## 规则二: 图表选型

### 用 ASCII art

- 简单线性流程: `A → B → C`
- 方框内的结构描述 (内存布局、数据结构)
- 树状缩进 (调用链、目录结构)

### 用 mermaid

- **流程图** (flowchart): 有分支/判断/循环
- **时序图** (sequenceDiagram): 多方交互、消息传递
- **状态图** (stateDiagram-v2): 状态机、生命周期

### 判断标准

```
多于 2 个参与方的交互?       → mermaid sequenceDiagram
有条件分支或循环?             → mermaid flowchart
是状态转换?                   → mermaid stateDiagram-v2
只是线性展示结构/布局/调用链? → ASCII art
```

---

## 规则三: ASCII Art 对齐

### 宽度计算

```
display_width(字符串) = 各字符宽度之和
  - east_asian_width(c) ∈ {F, W} → 2 列 (汉字, 全角标点)
  - 其余字符                     → 1 列 (ASCII, box-drawing, 半角标点)
```

方框内所有行 (从 `┌` 到 `└`) 的 display width 必须相同。

### 字符宽度速查

| 字符               | 宽度   | 类别         |
| ------------------ | ------ | ------------ |
| `a-z A-Z 0-9`      | 1      | ASCII        |
| `│┌└├─┐┘┤┬┴═`      | 1      | Box-drawing  |
| `←→↑↓▼▲`           | 1      | 箭头         |
| 空格               | 1      | 空白         |
| `中文汉字`         | 每字 2 | CJK 表意文字 |
| `（）：，、。「」` | 每字 2 | 全角标点     |
| `(),:.""`          | 每字 1 | 半角标点     |

### 避坑策略

方框内优先用**半角标点**减少宽度计算失误:

- 用 `()` 不用 `（）`
- 用 `:` 不用 `：`
- 用 `,` 不用 `，`

### 验证

写完后用脚本检测:

```bash
python3 ~/.agents/local-skills/writing-markdown/check_alignment.py <file.md>
```

---

## 完整工作流

```
1. 写 markdown 正文
2. 若需要图表, 选择图表类型 (mermaid or ASCII art)
3. 若发现 ASCII art 方框、box-drawing 图、混排对齐文本或终端显示错位:
   3a. 方框内用半角标点
   3b. 运行 check_alignment.py 验证对齐
   3c. 修复不对齐的行
4. prettier --write <file.md>
```

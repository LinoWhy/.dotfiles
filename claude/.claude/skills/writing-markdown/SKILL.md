---
name: writing-markdown
description: Use when creating or editing ASCII art box-drawing diagrams in markdown code fences that contain CJK characters (Chinese, Japanese, Korean). Triggers on misaligned boxes, mixed CJK/ASCII content lines, or when writing new box-drawing diagrams with non-ASCII text. Also use when user reports alignment issues in terminal display of markdown files.
---

# Markdown 写作规范

## 三条核心规则

1. **ASCII art 方框必须对齐** — 中文字符 2 列, ASCII 字符 1 列, 方框内每行 display width 必须一致
2. **复杂图用 mermaid** — 流程图、时序图、状态图等用 mermaid 代码块, 不要用 ASCII art 硬画
3. **写完用 prettier 格式化** — 统一缩进、空行、表格对齐

---

## 规则一: ASCII Art 对齐

### 宽度计算

```
display_width(字符串) = 各字符宽度之和
  - east_asian_width(c) ∈ {F, W} → 2 列 (汉字, 全角标点)
  - 其余字符                     → 1 列 (ASCII, box-drawing, 半角标点)
```

方框内所有行 (从 `┌` 到 `└`) 的 display width 必须相同。

### 字符宽度速查

| 字符                 | 宽度   | 类别           |
| -------------------- | ------ | -------------- |
| `a-z A-Z 0-9`       | 1      | ASCII          |
| `│┌└├─┐┘┤┬┴═`       | 1      | Box-drawing    |
| `←→↑↓▼▲`            | 1      | 箭头           |
| 空格                 | 1      | 空白           |
| `中文汉字`           | 每字 2 | CJK 表意文字   |
| `（）：，、。「」`   | 每字 2 | 全角标点       |
| `(),:.""`            | 每字 1 | 半角标点       |

### 避坑策略

方框内优先用**半角标点**减少宽度计算失误:

- 用 `()` 不用 `（）`
- 用 `:` 不用 `：`
- 用 `,` 不用 `，`

### 验证

写完后用脚本检测:

```bash
python3 ~/.claude/skills/writing-markdown/check_alignment.py <file.md>
```

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

## 规则三: Prettier 格式化

markdown 写完后执行:

```bash
prettier --write <file.md>
```

prettier 不会改动代码块内部, 所以 ASCII art 对齐仍需手动保证。

---

## 完整工作流

```
1. 写 markdown 正文
2. 选择图表类型 (ASCII art or mermaid)
3. 若有 ASCII art 方框:
   3a. 方框内用半角标点
   3b. 运行 check_alignment.py 验证对齐
   3c. 修复不对齐的行
4. prettier --write <file.md>
```

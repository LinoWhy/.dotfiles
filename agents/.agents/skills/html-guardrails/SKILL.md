---
name: html-guardrails
description: 创建、排版、实质修改或审阅 HTML 页面时使用，包括文章、报告、文档与展示页；仅修改文稿文字不触发。
---

# HTML 页面呈现与交付

以 Markdown 保存内容，复用固定模板、样式和脚本生成单个 HTML。已有项目的生成流程和设计约定优先；默认不部署、不启动服务。

## 固定资源与创作范围

- [assets/page.html](assets/page.html) 提供阅读页结构，[assets/page.css](assets/page.css) 提供自适应排版，[assets/page.js](assets/page.js) 提供目录切换、定位、图片放大和代码复制。左侧目录展开为完整面板，收起后保留窄栏图标；正文为其预留空间，窄屏选择章节后关闭目录。
- [scripts/render.py](scripts/render.py) 负责 Markdown 转换、目录生成与资源内联。普通阅读页直接使用这些资源，不为每篇文章重写生成逻辑。
- Agent 根据任务编写内容、安排章节、选择页面语言和制作图示；需要额外样式时，写入任务目录中的 CSS 文件，通过 `--css` 加载。
- 展示页按内容需要调整结构，可基于固定资源定制；不要强行套用长文布局，也不要把某次任务的设计写回通用模板。

## 编写 Markdown

在任务目录编写 Markdown 源文件，章节数量与顺序由内容决定。

- 用 `#` 提供页面标题，`##`、`###` 自动生成页内目录；正文不重复维护目录清单。
- 支持表格、围栏代码块与属性列表，对应 `tables`、`fenced_code`、`attr_list`、`toc` 扩展。
- 本地图片按 Markdown 文件所在目录解析并内嵌。可信的原生 HTML 和静态 SVG 可直接用于内容。
- 流程图、时序图等可直接写在 `mermaid` 围栏代码块中，由浏览器从源码生成 SVG；不需要先运行 CLI。已有 SVG 或图片仍可直接使用。图示默认居中，点击或按 Enter 可在浮层中放大查看，再次点击或按 Esc 返回。
- 正文统一限制内容宽度，标题、代码、表格与图示均在该范围内排版。宽代码和过宽、过长的表格在各自区域内滚动，正文在窄屏下自然重排。

## 生成页面

生成端使用 Linux 或 macOS 上的 Python 3.9+，仅依赖纯 Python 的 Markdown 库；不下载或管理平台二进制。

```bash
python3 -m pip install Markdown
```

以下命令从本技能目录执行；在其他目录使用 `render.py` 的实际路径：

```bash
python3 scripts/render.py input.md -o output.html
```

可选参数：

- `--title "Page title"`：覆盖从一级标题取得的页面标题。
- `--lang en`：设置 HTML 语言属性，默认 `zh-CN`。
- `--css /path/to/project.css`：在固定样式之后追加项目样式。

输出 HTML 内联 CSS、JavaScript 和本地图片，可直接用 `file://` 打开，也可放入用户已有 HTTP 服务目录。默认不引入 CDN、外部字体、图标库、站点搜索或 404 页面。

仅包含 Mermaid 代码块时，生成器会内嵌随技能提供的 [Mermaid Tiny 12.2.0](https://mermaid.js.org/config/usage.html#tiny-mermaid) 浏览器脚本和初始化代码；生成与阅读均不联网下载。[assets/vendor/](assets/vendor/) 保存第三方绘图引擎及许可证，[assets/mermaid.js](assets/mermaid.js) 负责主题配置和页面接入。引擎约 2.7 MB，支持常用流程图、时序图等，不含架构图、思维导图及 ELK 布局。普通文稿不携带此依赖，生成端不增加 Python 包或 Node 工具。

## 检查与交付

从读者实际使用的入口打开成品，查看桌面与窄屏下的正文、表格和图示，测试目录入口与章节跳转，确认所需资源能加载。使用现有浏览器能力完成这些检查；无法实际打开页面时，说明未验证项，不把源码检查当成渲染验证。

交付 Markdown 源文件和生成的 HTML，说明页面入口及实际存在的使用限制。仅在任务需要时附项目 CSS 或定制资源。

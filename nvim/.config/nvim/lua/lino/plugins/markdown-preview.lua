return {
  "LinoWhy/markdown-preview.nvim",
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
  ft = "markdown",
  config = function()
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_combine_preview = 1
    vim.g.mkdp_browser = "Google Chrome"
    vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/assets/markdown-preview.css"
  end,
}

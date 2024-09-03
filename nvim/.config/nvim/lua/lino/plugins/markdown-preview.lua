return {
  "iamcco/markdown-preview.nvim",
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
  ft = "markdown",
  config = function()
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_combine_preview = 1
  end,
}

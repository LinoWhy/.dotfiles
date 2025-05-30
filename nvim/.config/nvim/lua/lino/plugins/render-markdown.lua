return {
  "MeanderingProgrammer/render-markdown.nvim",
  build = "pip install pylatexenc",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  keys = { { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown" } },
  opts = {
    heading = { icons = {} },
    code = { width = "block", right_pad = 1 },
    checkbox = {
      custom = {
        todo = { -- todo is the default config name
          raw = "[-]",
          rendered = " ",
          highlight = "RenderMarkdownDash",
          scope_highlight = "@markup.strikethrough",
        },
        defer = {
          raw = "[>]",
          rendered = "󱦟 ",
          highlight = "RenderMarkdownWarn",
          scope_highlight = nil,
        },
        important = {
          raw = "[!]",
          rendered = "󱈸 ",
          highlight = "RenderMarkdownError",
          scope_highlight = nil,
        },
      },
    },
    sign = { enabled = false },
  },
}

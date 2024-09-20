return {
  "MeanderingProgrammer/render-markdown.nvim",
  build = "pip install pylatexenc",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  keys = { { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown" } },
  opts = {
    heading = {
      icons = { "𝄞 ", "𝅘𝅥𝅮 ", "𝅘𝅥 ", "𝅗𝅥 ", "𝅜 ", "𝄡 " },
    },
  },
}

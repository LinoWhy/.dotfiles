return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "Avante" },
      opts = { file_types = { "markdown", "Avante" } },
    },
  },
  opts = {
    provider = "deepseek-volcengine",
    vendors = {
      ["deepseek-volcengine"] = {
        __inherited_from = "openai",
        endpoint = "https://ark.cn-beijing.volces.com/api/v3",
        model = "ep-20250221160409-ltwbr",
        api_key_name = "ARK_API_KEY",
        disable_tools = true,
      },
    },
    windows = {
      width = 40,
    },
    mappings = {
      -- ask = "<leader>aA",
      toggle = { default = "<leader>aa" },
    },
  },
}

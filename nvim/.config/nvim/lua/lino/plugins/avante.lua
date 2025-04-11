return {
  {
    "yetone/avante.nvim",
    enabled = Lino.use_ai,
    build = "make",
    cmd = { "AvanteAsk", "AvanteChat" },
    -- Dependencies are not necessary, as these modules are loaded on-demand
    -- dependencies = {
    --   "stevearc/dressing.nvim",
    --   "nvim-lua/plenary.nvim",
    --   "MunifTanjim/nui.nvim",
    --   "nvim-telescope/telescope.nvim",
    -- },
    opts = {
      provider = "deepseek-V3",
      vendors = {
        ["deepseek-V3"] = {
          __inherited_from = "openai",
          endpoint = "https://ark.cn-beijing.volces.com/api/v3",
          model = "deepseek-v3-241226",
          api_key_name = "ARK_API_KEY",
          disable_tools = true,
        },
        ["deepseek-R1"] = {
          __inherited_from = "openai",
          endpoint = "https://ark.cn-beijing.volces.com/api/v3",
          model = "ep-20250221160409-ltwbr",
          api_key_name = "ARK_API_KEY",
          disable_tools = true,
        },
      },
      hints = { enabled = false },
      windows = {
        width = 40,
        ask = {
          start_insert = false,
          focus_on_apply = "theirs",
        },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = { file_types = { "markdown", "Avante" } },
  },
}

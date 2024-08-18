return {
  "Exafunction/codeium.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({ detect_proxy = true })
  end,
}

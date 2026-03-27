return {
  "retran/meow.yarn.nvim",
  cmd = { "MeowYarn" },
  keys = {
    { "<leader>lc", "<cmd>MeowYarn call callers<cr>", desc = "Call Hierarchy" },
    { "<leader>lt", "<cmd>MeowYarn type super<cr>", desc = "Type Hierarchy" },
  },
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("meow.yarn").setup({
      -- Your custom configuration goes here
    })
  end,
}

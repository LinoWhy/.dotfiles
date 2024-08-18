return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = { "BufRead", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({
      move_cursor = false,
    })
    vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { link = "@text.uri" })
  end,
}

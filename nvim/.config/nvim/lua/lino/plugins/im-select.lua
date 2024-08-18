return {
  {
    "keaising/im-select.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("im_select").setup({})
    end,
  },
}

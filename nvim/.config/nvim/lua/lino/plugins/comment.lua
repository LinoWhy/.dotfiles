return {
  "numToStr/Comment.nvim",
  event = { "BufRead", "BufNewFile" },
  keys = {
    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current linewise" },
    { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", mode = "x", desc = "Comment toggle linewise" },
  },
  opts = {
    ignore = "^$", -- ignores empty lines
  },
}

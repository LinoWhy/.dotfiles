local keys = {
  -- ]/[
  { "]c", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
  { "[c", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
  -- <leader>g
  { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
  { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
  { "<leader>gD", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle Deleted" },
  { "<leader>gB", "<cmd>Gitsigns blame<cr>", desc = "Blame" },
  { "<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line" },
  { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
  { "<leader>gq", "<cmd>Gitsigns setloclist<cr>", desc = "Hunks in Loclist" },
  { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
  { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
  { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
  { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
  { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
  -- <leader>t
  { "<leader>tl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Git Blame" },
}

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufRead", "BufNewFile" },
  cmd = "Gitsigns",
  keys = keys,
  opts = {
    signs = {
      add = { text = Lino.icons.ui.BoldLineMiddle },
      change = { text = Lino.icons.ui.BoldLineMiddle },
      delete = { text = Lino.icons.ui.Triangle },
      topdelete = { text = Lino.icons.ui.Triangle },
      changedelete = { text = Lino.icons.ui.BoldLineMiddle },
    },
    signs_staged = {
      add = { text = Lino.icons.ui.BoldLineMiddle },
      change = { text = Lino.icons.ui.BoldLineMiddle },
      delete = { text = Lino.icons.ui.Triangle },
      topdelete = { text = Lino.icons.ui.Triangle },
      changedelete = { text = Lino.icons.ui.BoldLineMiddle },
    },
    signs_staged_enable = false,
    attach_to_untracked = true,
    current_line_blame_opts = { delay = 300 },
    update_debounce = 200,
    -- Options passed to nvim_open_win
    preview_config = { border = "rounded" },
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
    vim.api.nvim_set_hl(0, "GitsignsCurrentLineBlame", { fg = "#24273a", bg = "#f0c6c6", italic = true })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsDelete" })
  end,
}

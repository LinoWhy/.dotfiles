return {
  "andymass/vim-matchup",
  enabled = false,
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "\\", "<plug>(matchup-%)", mode = { "n", "x", "o" } },
    { "i\\", "<plug>(matchup-i%)", mode = { "x", "o" } },
    { "a\\", "<plug>(matchup-a%)", mode = { "x", "o" } },
  },
  config = function()
    vim.g.matchup_mappings_enabled = 0
    vim.g.matchup_matchparen_enabled = 0 -- FIXME: conflict with nvim-cmp
    vim.g.matchup_mouse_enabled = 0
  end,
}

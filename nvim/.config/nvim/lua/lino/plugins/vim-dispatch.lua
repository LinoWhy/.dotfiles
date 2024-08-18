return {
  "tpope/vim-dispatch",
  cmd = { "Make", "Dispatch", "Focus", "Start" },
  init = function()
    vim.g.dispatch_no_maps = true
  end,
}

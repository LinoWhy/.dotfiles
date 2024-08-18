return {
  -- requires neovim nightly
  "lewis6991/satellite.nvim",
  event = { "BufRead", "BufNewFile" },
  opts = {
    current_only = true,
  },
}

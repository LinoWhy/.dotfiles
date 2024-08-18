return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec", "TermSelect" },
    keys = {
      { "<A-1>", "<cmd>ToggleTerm direction=horizontal<cr>", mode = { "n", "t" }, desc = "Horizontal Terminal" },
      { "<A-2>", "<cmd>ToggleTerm direction=vertical<cr>", mode = { "n", "t" }, desc = "Vertical Terminal" },
      { "<A-3>", "<cmd>ToggleTerm direction=float<cr>", mode = { "n", "t" }, desc = "Float Terminal" },
      { "<A-4>", "<cmd>ToggleTerm direction=tab<cr>", mode = { "n", "t" }, desc = "Tab Terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.3
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      shade_terminals = false,
      float_opts = {
        -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        border = "curved",
        -- width = <value>,
        -- height = <value>,
        winblend = 0,
      },
    },
  },
}

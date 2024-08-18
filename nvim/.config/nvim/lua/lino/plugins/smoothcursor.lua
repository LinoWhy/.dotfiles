local color = "SmoothCursorAqua"

return {
  "gen740/SmoothCursor.nvim",
  enabled = false,
  -- enabled = not vim.g.neovide,
  event = { "BufRead", "BufNewFile" },
  opts = {
    autostart = true,
    cursor = nil, -- Show cursor only in motion
    fancy = {
      enable = true, -- enable fancy mode
      head = { cursor = "", texthl = color, linehl = nil },
      body = {
        -- no rainbow
        { cursor = "●", texthl = color },
        { cursor = "●", texthl = color },
        { cursor = "•", texthl = color },
        { cursor = "•", texthl = color },
        { cursor = ".", texthl = color },
        { cursor = ".", texthl = color },
      },
      tail = { cursor = "", texthl = color },
    },
    disable_float_win = true,
    disabled_filetypes = {
      "DressingSelect",
      "DiffviewFiles",
      "DiffviewFileHistory",
      "PlenaryTestPopup",
      "alpha",
      "checkhealth",
      "dap-float",
      "dap-repl",
      "dapui_hover",
      "floaterm",
      "help",
      "lspinfo",
      "man",
      "neotest-output",
      "neotest-output-panel",
      "neotest-summary",
      "notify",
      "null-ls-info",
      "qf",
      "query",
      "spectre_panel",
      "startuptime",
      "tsplayground",
    },
  },
}

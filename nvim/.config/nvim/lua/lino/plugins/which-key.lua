return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  -- tables of opts will be merged and passed to config
  -- Define groups name here, keymaps to be defined in corresponding plugins
  opts = {
    preset = "modern",
    icons = { mappings = false },
    spec = {
      mode = { "n", "v" },
      { "g", group = "goto" },
      { "]", group = "next" },
      { "[", group = "prev" },
      { "<leader>b", group = "Buffer" },
      { "<leader>d", group = "Debug" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>n", group = "Noice" },
      { "<leader>r", group = "Run" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Toggle" },
      { "<leader><tab>", group = "Tab" },
    },
  },
}

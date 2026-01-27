return {
  "olimorris/persisted.nvim",
  cmd = { "Persisted" },
  keys = {
    -- stylua: ignore
    { "<leader>Q", function() vim.cmd("Persisted save") vim.cmd("qa") end, desc = "Save Session & Quit" },
  },
  config = function()
    require("persisted").setup({ autostart = false })
  end,
}

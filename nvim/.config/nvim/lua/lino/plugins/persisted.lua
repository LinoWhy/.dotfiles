return {
  "olimorris/persisted.nvim",
  cmd = {
    "SessionToggle",
    "SessionStart",
    "SessionStop",
    "SessionSave",
    "SessionLoad",
    "SessionLoadLast",
    "SessionLoadFromFile",
    "SessionDelete",
  },
  keys = {
    -- stylua: ignore
    { "<leader>Q", function() vim.cmd("SessionSave") vim.cmd("qa") end, desc = "Save Session & Quit" },
  },
  config = function()
    require("persisted").setup({ autostart = false })
  end,
}

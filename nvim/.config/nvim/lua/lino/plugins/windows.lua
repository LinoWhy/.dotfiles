local enable_autowidth = false

local function toggle()
  enable_autowidth = not enable_autowidth
  vim.cmd("WindowsToggleAutowidth")
  vim.cmd([[set equalalways!]]) -- default to on
  if enable_autowidth then
    print("resize, no equalalways")
  else
    print("no resize, equalalways")
  end
end

return {
  "anuvyklack/windows.nvim",
  dependencies = "anuvyklack/middleclass",
  cmd = {
    "WindowsMaximize",
    "WindowsEqualize",
    "WindowsToggleAutowidth",
  },
  keys = {
    { "<leader>tr", toggle, desc = "Toggle Window Resize" },
    { "<C-w>z", "<cmd>WindowsMaximize<cr>", desc = "Toggle Window Maximize" },
  },
  opts = {
    autowidth = {
      enable = enable_autowidth,
      winwidth = Lino.extra_width, -- textwidth + winwidth
    },
    animation = { enable = false },
  },
}

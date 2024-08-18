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
  event = { "BufRead", "BufNewFile" },
  keys = {
    { "<space>tr", toggle, desc = "Toggle Auto Resize" },
  },
  opts = {
    autowidth = {
      enable = enable_autowidth,
      winwidth = Lino.extra_width, -- textwidth + winwidth
    },
  },
}

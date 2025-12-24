local M = {}
local wezterm = require("wezterm")

function M.setup(config)
  config.font = wezterm.font_with_fallback({
    {
      family = "Recursive Mono Casual Static Freeze",
      weight = "Medium",
    },
    { family = "Symbols Nerd Font Mono", scale = 0.75 },
    "Noto Color Emoji",
    "WenQuanYi Micro Hei",
  })
end

function M.ime_switch(value)
  if value == "EN" then
    wezterm.background_child_process({
      "ibus",
      "engine",
      "xkb:us::eng",
    })
  end
end

return M

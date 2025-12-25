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
      "bash",
      "-c",
      -- NOTE: may be triggered more than once, especially with "vim-tmux-navigator"
      -- "ibus engine | grep -iq eng || xdotool key super+space",
      --
      -- install gnome shell extension: madhead/shyriiwook
      'gdbus call --session --dest org.gnome.Shell --object-path /me/madhead/Shyriiwook --method me.madhead.Shyriiwook.activate "us"',
    })
  end
end

return M

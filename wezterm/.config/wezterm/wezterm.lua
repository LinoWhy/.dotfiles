local wezterm = require("wezterm")
local act = wezterm.action

local color_scheme = "Catppuccin Macchiato"
local use_color_scheme = true

wezterm.on("toggle-color-scheme", function(window, _)
  use_color_scheme = not use_color_scheme
  local scheme = use_color_scheme and color_scheme or ""
  window:set_config_overrides({ color_scheme = scheme })
end)

local config = {
  color_scheme = color_scheme,

  default_prog = { "zsh", "-l" },

  font = wezterm.font_with_fallback({
    {
      family = "Recursive Mono Casual Static Freeze",
      weight = "Medium",
    },
    { family = "Symbols Nerd Font Mono", scale = 0.75 },
    "Noto Color Emoji",
  }),
  font_size = 10.5,
  cell_width = 1.0,

  warn_about_missing_glyphs = false,
  adjust_window_size_when_changing_font_size = false,
  allow_square_glyphs_to_overflow_width = "Never",
  use_cap_height_to_scale_fallback_fonts = true,

  disable_default_key_bindings = true,
  keys = {
    -- spawn & close
    { key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
    { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
    -- tab navigate
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- copy & paste
    { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
    -- pane & navigate
    { key = "_", mods = "SHIFT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "|", mods = "SHIFT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
    -- command palette
    { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- font size
    { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },
    -- toggle full screen
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
    -- toggle color scheme
    { key = "R", mods = "SHIFT|CTRL", action = act.EmitEvent("toggle-color-scheme") },
  },

  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_max_width = 60,

  window_decorations = "NONE",
  window_padding = {
    left = 1,
    right = 1,
    top = 0,
    bottom = 0,
  },

  scrollback_lines = 9999,
  max_fps = 120,
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  require("windows").setup(config)
elseif wezterm.target_triple == "aarch64-apple-darwin" then
  require("macos").setup(config)
end

return config

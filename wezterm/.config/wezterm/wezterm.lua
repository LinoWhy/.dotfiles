local wezterm = require("wezterm")
local act = wezterm.action
local c = wezterm.config_builder()

local platform_modules = {
  ["x86_64-pc-windows-msvc"] = "windows",
  ["aarch64-apple-darwin"] = "macos",
  ["x86_64-unknown-linux-gnu"] = "linux",
}
local platform = require(platform_modules[wezterm.target_triple])
local switch_ime = platform.switch_ime or nil

wezterm.on("user-var-changed", function(_, _, name, value)
  if name == "wez_ime" and type(switch_ime) == "function" then
    switch_ime(value)
  end
end)

local function switch_tab_and_ime(relative)
  return wezterm.action_callback(function(window, pane)
    window:perform_action(act.ActivateTabRelative(relative), pane)
    if type(switch_ime) == "function" then
      switch_ime("EN")
    end
  end)
end

local use_color_scheme = true
local function toggle_color_scheme()
  return wezterm.action_callback(function(window, _)
    use_color_scheme = not use_color_scheme
    local scheme = use_color_scheme and c.color_scheme or ""
    window:set_config_overrides({ color_scheme = scheme })
  end)
end

-- Common settings
c.default_prog = { "zsh", "-l" }
c.scrollback_lines = 9999
c.max_fps = 120

-- Appearance
c.color_scheme = "Catppuccin Macchiato"
c.hide_tab_bar_if_only_one_tab = true
c.use_fancy_tab_bar = false
c.tab_max_width = 60

c.window_decorations = "NONE"
c.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 0,
}

-- Font
c.font = wezterm.font_with_fallback({
  {
    family = "Recursive Mono Casual Static Freeze",
    weight = "Medium",
  },
  { family = "Symbols Nerd Font Mono", scale = 0.75 },
  "Noto Color Emoji",
})
c.font_size = 10.5
c.cell_width = 1.0

c.warn_about_missing_glyphs = false
c.adjust_window_size_when_changing_font_size = false
c.allow_square_glyphs_to_overflow_width = "Never"
c.use_cap_height_to_scale_fallback_fonts = true

-- Keybindings
c.disable_default_key_bindings = true
c.keys = {
  -- spawn & close
  { key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
  { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  -- tab navigate
  { key = "Tab", mods = "CTRL", action = switch_tab_and_ime(1) },
  { key = "Tab", mods = "SHIFT|CTRL", action = switch_tab_and_ime(-1) },
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
  { key = "R", mods = "SHIFT|CTRL", action = toggle_color_scheme() },
}

-- Platform specific settings
platform.setup(c)

return c

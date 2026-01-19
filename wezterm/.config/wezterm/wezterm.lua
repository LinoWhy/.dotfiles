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
local tmux_windows = require("tmux_windows")

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
  if type(switch_ime) == "function" then
    switch_ime("EN")
  end
end)

wezterm.on("gui-attached", function()
  if type(switch_ime) == "function" then
    switch_ime("EN")
  end
end)

wezterm.on("user-var-changed", function(_, pane, name, value)
  if name == "wez_ime" and type(switch_ime) == "function" then
    switch_ime(value)
  end
  if name == "tmux_windows" then
    tmux_windows.on_user_var_changed(name, value)
  end
end)

wezterm.on("update-status", function(window, pane)
  tmux_windows.on_update_status(window, pane)
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
      return title
    end
    return tab_info.active_pane.title
  end

  local title = tab_title(tab)
  title = " " .. title .. " "
  title = wezterm.truncate_right(title, max_width)
  return title
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
    local overrides = window:get_config_overrides() or {}
    if use_color_scheme then
      overrides.color_scheme = c.color_scheme
      overrides.colors = c.colors
    else
      overrides.color_scheme = nil
      overrides.colors = wezterm.color.get_default_colors()
    end
    window:set_config_overrides(overrides)
  end)
end

local function toggle_tab_bar()
  return wezterm.action_callback(function(window, _)
    c.enable_tab_bar = not c.enable_tab_bar
    window:set_config_overrides({ enable_tab_bar = c.enable_tab_bar })
  end)
end

-- Common settings
c.default_prog = { "zsh", "-l" }
c.scrollback_lines = 9999
c.max_fps = 120

-- Appearance
c.color_scheme = "Catppuccin Macchiato"
c.enable_tab_bar = true
c.tab_bar_at_bottom = false
c.hide_tab_bar_if_only_one_tab = false
c.use_fancy_tab_bar = false
c.tab_max_width = 60
c.show_new_tab_button_in_tab_bar = false
c.show_tab_index_in_tab_bar = false
c.colors = {
  tab_bar = {
    background = "#24273a",
    inactive_tab = {
      bg_color = "#24273a",
      fg_color = "#cad3f5",
    },
  },
}

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
  { family = "LXGW WenKai GB", scale = 1.1 },
})
c.font_size = 11
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
  { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = false }) },
  -- tab navigate
  { key = "Tab", mods = "CTRL", action = switch_tab_and_ime(1) },
  { key = "Tab", mods = "SHIFT|CTRL", action = switch_tab_and_ime(-1) },
  { key = "S", mods = "SHIFT|CTRL", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS", title = "Tabs" }) },
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
  { key = "B", mods = "SHIFT|CTRL", action = toggle_tab_bar() },
}

-- Platform specific settings
platform.setup(c)

return c

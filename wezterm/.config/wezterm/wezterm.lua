local wezterm = require("wezterm")
local act = wezterm.action
local default_prog
local launch_menu = {}
local gitbash = { "D:\\programs\\Git\\bin\\bash.exe", "-i", "-l" }
local msys2 = { "D:\\programs\\msys64\\msys2_shell.cmd", "-defterm", "-here", "-no-start", "-ucrt64" }

-- Shell
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  default_prog = { "wsl.exe", "--cd", "~" }
  table.insert(launch_menu, {
    label = "PowerShell",
    args = { "powershell.exe", "-NoLogo" },
  })
  table.insert(launch_menu, {
    label = "Git Bash",
    args = gitbash,
  })
  table.insert(launch_menu, {
    label = "msys2 ucrt64",
    args = msys2,
  })
else
  default_prog = { "zsh", "-l" }
end

local config = {
  default_prog = default_prog,
  launch_menu = launch_menu,

  font = wezterm.font_with_fallback({
    {
      family = "Recursive Mono Casual Static Freeze",
    },
    {
      family = "Recursive Mono Casual Static",
      weight = "Medium",
      scale = 1,
      harfbuzz_features = {
        "dlig", -- code ligatures
        -- for CRSV<=0.5 (Roman/normal styles)
        -- "ss01", -- Single-story a
        -- "ss02", -- Single-story g
        "ss03", -- Simplified f
        "ss04", -- Simplified i
        "ss05", -- Simplified l
        "ss06", -- Simplified r
        -- for both Roman & Cursive styles
        -- "ss07", -- Simplified italic diagonals (kwxyz)
        "ss08", -- No-serif L and Z
        -- "ss09", -- Simplified 6 and 9
        "ss10", -- Dotted 0
        -- "ss11", -- Simplified 1
        "ss12", -- Simplified @
      },
    },
    {
      family = "Cascadia Code",
      scale = 1,
      harfbuzz_features = {
        -- "ss01", -- sytlistic italic
        "ss02", -- alternate ~=
        "ss03", -- serbian locl forms
        -- "ss19", -- slashed zero
      },
    },
    { family = "Symbols Nerd Font Mono", scale = 0.75 },
    "Noto Color Emoji",
    { family = "Delugia", scale = 1.1 },
  }),
  font_size = 10.5,
  cell_width = 1.0,
  -- line_height = 0.95,

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
    -- scroll
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
    { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
    { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
    -- search & copy mode
    { key = "F", mods = "SHIFT|CTRL", action = act.Search({ CaseSensitiveString = "" }) },
    { key = "Q", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
    -- command palette
    { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- font size
    { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },
    -- toggle full screen
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  },

  -- disable_default_mouse_bindings = true,
  -- mouse_bindings = {
  --   -- Bind 'Up' event of CTRL-Click to open hyperlinks
  --   {
  --     event = { Up = { streak = 1, button = "Left" } },
  --     mods = "CTRL",
  --     action = act.OpenLinkAtMouseCursor,
  --   },
  -- },

  color_scheme = "Catppuccin Macchiato", -- or Macchiato, Frappe, Latte

  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_max_width = 36,

  window_decorations = "RESIZE",
  window_padding = {
    left = 2,
    right = 6,
    top = 0,
    bottom = 0,
  },

  enable_scroll_bar = true,
  scrollback_lines = 9999999,
}

local use_color_scheme = true
wezterm.on("toggle-color-scheme", function(window, _)
  use_color_scheme = not use_color_scheme
  local scheme = use_color_scheme and config.color_scheme or ""
  window:set_config_overrides({ color_scheme = scheme })
end)

table.insert(config.keys, { key = "R", mods = "SHIFT|CTRL", action = act.EmitEvent("toggle-color-scheme") })

return config

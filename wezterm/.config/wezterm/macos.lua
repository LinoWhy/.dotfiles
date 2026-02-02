local M = {}
local wezterm = require("wezterm")

function M.setup(config)
  config.font_size = 14
  config.freetype_load_flags = "NO_HINTING" -- avoid font changed slightly on selection
  config.window_decorations = "RESIZE"
  config.native_macos_fullscreen_mode = true
end

function M.switch_ime(value)
  if value == "EN" then
    wezterm.background_child_process({
      "/opt/homebrew/bin/macism",
      "com.apple.keylayout.ABC",
    })
  end
end

return M

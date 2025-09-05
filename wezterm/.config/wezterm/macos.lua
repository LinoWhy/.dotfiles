local M = {}

function M.setup(config)
  config.font_size = 13.5
  config.window_decorations = "RESIZE"
  config.native_macos_fullscreen_mode = true
end

return M

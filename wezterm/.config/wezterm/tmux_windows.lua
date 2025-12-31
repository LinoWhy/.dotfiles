local wezterm = require("wezterm")

local M = {}

local tmux_windows_cache = {}

local function update_tmux_cache(value)
  if not value or value == "" then
    return
  end

  local sessions = {}
  for line in value:gmatch("[^\n]+") do
    local session, win_idx, active, path, flags = line:match("([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t(.*)")
    if session and win_idx and active and path then
      sessions[session] = sessions[session] or {}
      table.insert(sessions[session], {
        win_idx = win_idx,
        active = (active == "1"),
        path = path,
        flags = flags or "",
      })
    end
  end

  for session, windows in pairs(sessions) do
    tmux_windows_cache[session] = windows
  end
end

local function extract_session(title)
  if not title or title == "" then
    return ""
  end

  local match = ""
  for session, _ in pairs(tmux_windows_cache) do
    if title:find(session, 1, true) then
      if #session > #match then
        match = session
      end
    end
  end

  return match
end

local function format_tmux_windows_for_session(session)
  if not session or session == "" then
    return ""
  end

  local windows = tmux_windows_cache[session]
  if not windows or #windows == 0 then
    return ""
  end

  local parts = {}
  for i, win in ipairs(windows) do
    if i > 1 then
      table.insert(parts, { Text = " " })
    end

    local tail = win.path:gsub(".*/", "")
    local flags = win.flags:gsub("^%s+", ""):gsub("%s+$", "")
    local text = string.format(" %s: %s ", win.win_idx, tail)
    if flags ~= "" then
      text = string.format(" %s: %s %s ", win.win_idx, tail, flags)
    end
    if win.active then
      table.insert(parts, { Attribute = { Intensity = "Bold" } })
      table.insert(parts, { Attribute = { Underline = "Single" } })
      table.insert(parts, { Attribute = { Foreground = { PaletteIndex = 6 } } })
      table.insert(parts, { Text = text })
      table.insert(parts, { Attribute = { Intensity = "Normal" } })
      table.insert(parts, { Attribute = { Underline = "None" } })
      table.insert(parts, { Attribute = { Foreground = "Default" } })
    else
      table.insert(parts, { Text = text })
    end
  end

  return wezterm.format(parts) .. " |  "
end

function M.on_user_var_changed(name, value)
  if name == "tmux_windows" then
    update_tmux_cache(value)
  end
end

function M.on_update_status(window, pane)
  local title = ""
  if pane and type(pane.get_title) == "function" then
    title = pane:get_title()
  end
  if title == "" then
    local tab = window:active_tab()
    if tab and type(tab.active_pane) == "function" then
      local active_pane = tab:active_pane()
      if active_pane and active_pane.title then
        title = active_pane.title
      end
    end
    if title == "" and tab and type(tab.get_title) == "function" then
      title = tab:get_title()
    end
  end
  if title == "" and type(window.get_title) == "function" then
    title = window:get_title()
  end

  local session = extract_session(title)
  window:set_left_status(format_tmux_windows_for_session(session))
end

return M

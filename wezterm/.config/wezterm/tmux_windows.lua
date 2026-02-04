local wezterm = require("wezterm")

local M = {}

local tmux_windows_by_session = {}

local function parse_tmux_windows(value)
  local sessions = {}

  for line in value:gmatch("[^\n]+") do
    local fields = {}
    for field in (line .. "\t"):gmatch("([^\t]*)\t") do
      table.insert(fields, field)
    end

    local session, win_idx, active, path, flags = fields[1], fields[2], fields[3], fields[4], fields[5]
    local bell = flags:find("󰂞", 1, true) ~= nil
    local activity = flags:find("󱅫", 1, true) ~= nil

    sessions[session] = sessions[session] or {}
    table.insert(sessions[session], {
      win_idx = win_idx,
      active = (active == "1"),
      path = path:gsub(".*/", ""),
      flags = flags,
      bell = bell,
      activity = activity,
    })
  end

  return sessions
end

function M.on_user_var_changed(name, value)
  if name == "tmux_windows" then
    local parsed = parse_tmux_windows(value) or {}
    for session, windows in pairs(parsed) do
      tmux_windows_by_session[session] = windows
    end
  end
end

local function compute_tab_bar_width(window)
  local mux = window:mux_window()
  local cfg = window:effective_config()
  local max_width = cfg.tab_max_width

  local width = 0
  for _, info in ipairs(mux:tabs_with_info()) do
    local label = info.tab:active_pane():get_title()
    label = " " .. label .. " "
    label = wezterm.truncate_right(label, max_width)
    width = width + wezterm.column_width(label)
  end

  return width
end

function M.format_tab_title(tab, max_width)
  local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
      return title
    end
    return tab_info.active_pane.title
  end

  local title = tab_title(tab)
  title = " " .. title .. " "
  return wezterm.truncate_right(title, max_width)
end

local function format_status(windows, available_cols, total_cols, tab_bar_width, window)
  local scheme = wezterm.get_builtin_color_schemes()[window:effective_config().color_scheme]
  local colors = {
    black = { Color = scheme.ansi[1] },
    read = { Color = scheme.ansi[2] },
    green = { Color = scheme.ansi[3] },
    yellow = { Color = scheme.ansi[4] },
    blue = { Color = scheme.ansi[5] },
    magenta = { Color = scheme.ansi[6] },
    cyan = { Color = scheme.ansi[7] },
    white = { Color = scheme.ansi[8] },
    active_fg = { Color = scheme.tab_bar.active_tab.fg_color },
    active_bg = { Color = scheme.tab_bar.active_tab.bg_color },
  }

  local function build_left_status()
    if not windows or #windows == 0 then
      window:set_right_status("")
      return {}, 0
    end

    local parts = {}
    local width = 0

    -- local sep = ""
    -- table.insert(parts, { Attribute = { Intensity = "Bold" } })
    -- table.insert(parts, { Foreground = colors.active_bg })
    -- table.insert(parts, { Text = sep })
    -- table.insert(parts, "ResetAttributes")
    -- width = wezterm.column_width(sep)

    for _, win in ipairs(windows) do
      table.insert(parts, { Text = " " })
      width = width + 1
      local flags = win.flags
      local label = string.format(" %s: %s%s", win.win_idx, win.path, flags)

      if win.active then
        table.insert(parts, { Attribute = { Intensity = "Bold" } })
        table.insert(parts, { Attribute = { Underline = "Single" } })
        table.insert(parts, { Foreground = colors.cyan })
        table.insert(parts, { Text = label })
        table.insert(parts, "ResetAttributes")
      elseif win.bell then
        table.insert(parts, { Foreground = colors.yellow })
        table.insert(parts, { Text = label })
        table.insert(parts, "ResetAttributes")
      elseif win.activity then
        table.insert(parts, { Foreground = colors.magenta })
        table.insert(parts, { Text = label })
        table.insert(parts, "ResetAttributes")
      else
        table.insert(parts, { Text = label })
      end
      width = width + wezterm.column_width(label)
    end

    return parts, width
  end

  local function build_right_status()
    local parts = {}
    local width = 0

    local batteries = wezterm.battery_info()
    if #batteries > 0 then
      local text = string.format("  %.0f%% ", batteries[1].state_of_charge * 100)
      table.insert(parts, { Foreground = colors.cyan })
      table.insert(parts, { Text = text })
      table.insert(parts, "ResetAttributes")
      width = width + wezterm.column_width(text)
    end

    local time_text = wezterm.strftime(" %H:%M ")
    table.insert(parts, { Foreground = colors.active_bg })
    table.insert(parts, { Text = time_text })
    table.insert(parts, "ResetAttributes")
    width = width + wezterm.column_width(time_text)

    return parts, width
  end

  local parts, left_width = build_left_status()
  local right_parts, right_width = build_right_status()

  -- center the window lists
  if available_cols and available_cols > 0 then
    local left_pad = 16
    local desired_left_start = math.floor((total_cols - left_width) / 2) - tab_bar_width
    if desired_left_start > 0 and desired_left_start + left_width + right_width <= available_cols then
      left_pad = desired_left_start
    end
    table.insert(parts, 1, { Text = string.rep(" ", left_pad) })
    left_width = left_width + left_pad
    local middle_pad = available_cols - left_width - right_width
    if middle_pad > 0 then
      table.insert(parts, { Text = string.rep(" ", middle_pad) })
    end
  end

  for _, item in ipairs(right_parts) do
    table.insert(parts, item)
  end

  return wezterm.format(parts)
end

function M.on_update_status(window, pane)
  window:set_left_status("")

  local session = pane:get_title():gsub("^%s*", ""):gsub("%s@.*$", "")
  local windows = tmux_windows_by_session[session]

  local cols = pane:get_dimensions().cols
  local tab_bar_width = compute_tab_bar_width(window)
  local available_cols = math.max(cols - tab_bar_width, 0)
  window:set_right_status(format_status(windows, available_cols, cols, tab_bar_width, window))
end

function M.setup(c)
  c.show_tab_index_in_tab_bar = false

  wezterm.on("user-var-changed", function(_, _, name, value)
    if name == "tmux_windows" then
      M.on_user_var_changed(name, value)
    end
  end)

  wezterm.on("update-status", function(window, pane)
    M.on_update_status(window, pane)
  end)

  wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
    return M.format_tab_title(tab, max_width)
  end)
end

return M

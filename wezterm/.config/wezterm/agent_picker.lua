local wezterm = require("wezterm")

local M = {}
local colors = { "#EED49F", "#8AADF4", "#C6A0F6", "#8BD5CA", "#F5A97F", "#F5BDE6" }
local query = table.concat({
  "unset TMUX",
  'test -x "$HOME/.config/tmux/scripts/agent-picker/pick" || exit 0',
  'printf "home\\t%s\\n" "$HOME"',
  "tmux list-clients -F 'client\t#{client_tty}\t#{session_id}\t#{session_name}'",
  '"$HOME/.config/tmux/scripts/agent-picker/pick" --list',
}, "\n")

local function quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function run(source, command)
  command = "set -e\n" .. command
  local args
  if source.ssh then
    args = {
      "ssh",
      "-T",
      "-o",
      "BatchMode=yes",
      "-o",
      "ConnectTimeout=3",
      "-o",
      "PermitLocalCommand=no",
      "-o",
      "ForwardX11=no",
      "-o",
      "ForwardAgent=no",
      "-o",
      "ClearAllForwardings=yes",
      "-o",
      "RemoteCommand=none",
    }
    for _, arg in ipairs(source.ssh) do
      table.insert(args, arg)
    end
    table.insert(args, 'exec "$SHELL" -lc ' .. quote(command))
  else
    args = { os.getenv("SHELL") or "/bin/sh", "-lc", command }
  end
  local ok, output, err = wezterm.run_child_process(args)
  assert(ok, err)
  return output
end

local function ssh_args(process)
  if not process then
    return
  end
  if process.executable:match("([^/]+)$") ~= "ssh" then
    for _, child in pairs(process.children) do
      local args = ssh_args(child)
      if args then
        return args
      end
    end
    return
  end
  local argv, args, index = process.argv, {}, 2
  local keep, takes_value = "BbcFIiJlmoPpS", "BbcFIiJlmoPpSDEeLOQRWw"
  while index <= #argv do
    local arg = argv[index]
    if arg == "--" then
      table.insert(args, argv[index + 1])
      return args
    end
    if arg:sub(1, 1) ~= "-" then
      table.insert(args, arg)
      return args
    end
    for offset = 2, #arg do
      local option = arg:sub(offset, offset)
      if takes_value:find(option, 1, true) then
        local value = arg:sub(offset + 1)
        if value == "" then
          index = index + 1
          value = argv[index]
        end
        if keep:find(option, 1, true) then
          table.insert(args, "-" .. option)
          table.insert(args, value)
        end
        break
      elseif option == "4" or option == "6" then
        table.insert(args, "-" .. option)
      end
    end
    index = index + 1
  end
end

local function sources()
  local result, by_connection = { { label = "local", panes = {} } }, {}
  for _, window in ipairs(wezterm.mux.all_windows()) do
    for _, tab in ipairs(window:tabs()) do
      for _, pane in ipairs(tab:panes()) do
        table.insert(result[1].panes, pane)
        local ssh = ssh_args(pane:get_foreground_process_info())
        if ssh then
          local key = table.concat(ssh, "\0")
          if not by_connection[key] then
            by_connection[key] = { label = ssh[#ssh], ssh = ssh, panes = {} }
            table.insert(result, by_connection[key])
          end
          table.insert(by_connection[key].panes, pane)
        end
      end
    end
  end
  return result
end

local function collect()
  local agents = {}
  for index, source in ipairs(sources()) do
    source.color = colors[(index - 1) % #colors + 1]
    local home
    local clients, rows, locations = {}, {}, {}
    for line in run(source, query):gmatch("[^\n]+") do
      local fields = {}
      for value in (line .. "\t"):gmatch("(.-)\t") do
        table.insert(fields, value)
      end
      if fields[1] == "home" then
        home = fields[2]
      elseif fields[1] == "client" then
        table.insert(clients, fields)
      elseif fields[1]:sub(1, 1) == "%" then
        table.insert(rows, fields)
      end
    end
    for _, pane in ipairs(source.panes) do
      local session = pane:get_title():match("^ (.-) @")
      for _, client in ipairs(clients) do
        local matched = source.ssh and session == client[4] or not source.ssh and pane:get_tty_name() == client[2]
        if matched then
          table.insert(locations, { pane = pane, client = client[2], session = client[3] })
        end
      end
    end
    for _, row in ipairs(rows) do
      local location = locations[1]
      for _, candidate in ipairs(locations) do
        if candidate.session == row[2] then
          location = candidate
          break
        end
      end
      local path = row[7]
      if path == home or path:sub(1, #home + 1) == home .. "/" then
        path = "~" .. path:sub(#home + 1)
      end
      table.insert(agents, {
        source = source,
        id = row[1],
        location = location,
        cells = { source.label, row[4] .. (row[8] == "1" and "˚" or ""), row[5], row[6], path },
      })
    end
  end
  return agents
end

local function label(agent, widths)
  local parts = {}
  for column, value in ipairs(agent.cells) do
    local color = column == 3 and agent.source.color
    if widths[column] then
      value = value .. string.rep(" ", widths[column] - wezterm.column_width(value))
    end
    if color then
      table.insert(parts, { Foreground = { Color = color } })
    end
    table.insert(parts, { Text = value })
    if color then
      table.insert(parts, { Text = "\27[39m" })
    end
    if column < #agent.cells then
      table.insert(parts, { Text = " │ " })
    end
  end
  table.insert(parts, "ResetAttributes")
  return wezterm.format(parts)
end

local function jump(entry)
  run(
    entry.source,
    "unset TMUX\ntmux switch-client -c " .. quote(entry.location.client) .. " -t " .. quote(entry.id)
  )
  local target = entry.location.pane
  wezterm.mux.set_active_workspace(target:window():get_workspace())
  target:activate()
  target:window():gui_window():focus()
end

function M.action()
  return wezterm.action_callback(function(window, pane)
    local agents, widths, choices = collect(), {}, {}
    for _, agent in ipairs(agents) do
      for column = 1, #agent.cells - 1 do
        widths[column] = math.max(widths[column] or 0, wezterm.column_width(agent.cells[column]))
      end
    end
    for index, agent in ipairs(agents) do
      table.insert(choices, { id = tostring(index), label = label(agent, widths) })
    end
    window:perform_action(
      wezterm.action.InputSelector({
        title = "Agents",
        fuzzy = true,
        fuzzy_description = " agent: ",
        choices = choices,
        action = wezterm.action_callback(function(_, _, id)
          if id then
            jump(agents[tonumber(id)])
          end
        end),
      }),
      pane
    )
  end)
end

return M

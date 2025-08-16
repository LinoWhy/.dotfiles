local M = {}
local wezterm = require("wezterm")

function M.setup(config)
  local powershell = { "powershell.exe", "-NoLogo" }
  local wsl = { "wsl.exe", "--cd", "~" }

  local launch_menu = {
    {
      label = "PowerShell",
      args = powershell,
    },
    {
      label = "wsl",
      args = wsl,
    },
  }

  local success, stdout, _ = wezterm.run_child_process({ "where.exe", "git.exe" })
  if success then
    local git_path = wezterm.split_by_newlines(stdout)[1]
    local bash_path = git_path:gsub("cmd\\git.exe", "bin\\bash.exe")

    table.insert(launch_menu, {
      label = "git bash",
      args = { bash_path, "-i", "-l" },
    })
  end

  config.default_prog = powershell
  config.launch_menu = launch_menu
end

return M

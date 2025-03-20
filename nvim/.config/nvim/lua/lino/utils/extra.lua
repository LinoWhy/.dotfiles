---@class Utils.extra
local M = {}

---
---Check if the `plugin` is enabled.
---
---@param plugin string
---@return boolean
function M.has(plugin)
  local success, _ = pcall(require, "lazy.core.config")
  return success and require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---
---Create or get an autocommand group with `name`.
---
---@param name string
---@return integer
function M.augroup(name)
  return vim.api.nvim_create_augroup("lino_" .. name, { clear = true })
end

---
---Find a file with `filename` from current working directory upwards till home directory.
---
---@param filename string
function M.find_file(filename)
  local files = vim.fs.find(
    { filename },
    { path = vim.fn.getcwd(), upward = true, stop = "/home", limit = 1, type = "file" }
  )
  return files[1]
end

---
---Copy content to `file`
---
---@param file string
function M.write_to_file(file, content)
  local f = io.open(file, "w")
  if f then
    f:write(content)
    f:close()
  end
end

---
---Run `command` in tmux pane, toggleTemr or neovim command line
---
---@param command string
local function run_command(command)
  if os.getenv("TMUX") then
    local tmux_command = "tmux split-window -v -l 25 && tmux send-keys '" .. command .. "' Enter"
    os.execute(tmux_command)
    return
  end

  if pcall(vim.cmd, 'TermExec direction=float cmd="' .. command .. '"') then
    return
  end

  vim.cmd("!" .. command)
end

---
---Execute current file
---
function M.execute_current_file()
  vim.cmd.w()
  local file = vim.fn.expand("%:p")

  if vim.fn.getfperm(file):find("x", -3) ~= nil then
    run_command(file)
    return
  end

  local choice = vim.fn.confirm("Make current file executable?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd([[silent! !chmod +x %]])
    run_command(file)
  end
end

return M

---@class Utils.make
local M = {}
local cwd = vim.fn.getcwd()
local file = vim.fn.stdpath("cache") .. "/make.lua"

local make_cmds = { [cwd] = {} }
local new_command = {}
local run_cmd = {}
local dispatch_cmd = {}
local watch_cmd = {}

---Write option to cached file
local function write_option()
  local content = "return " .. vim.inspect(make_cmds)
  Utils.extra.write_to_file(file, content)
end

---Read option from cached file
local function read_options()
  local f, _ = loadfile(file)
  if f then
    make_cmds = vim.tbl_deep_extend("force", make_cmds, f())
  end
end

local function do_with_make(option)
  vim.cmd.set("makeprg=" .. option.program)
  vim.cmd("Make " .. option.argument)
end

local function do_with_dispatch(option)
  local cmd = option.program .. " " .. option.argument
  local command = [[echo 'Running "]] .. cmd .. [[" ...' && ]] .. cmd
  vim.cmd("Dispatch " .. command .. " && read")
end

local function do_with_term(option)
  local cmd = option.program .. " " .. option.argument
  local command = [[TermExec cmd=']] .. cmd .. [[']]
  vim.cmd(command)
end

---Select make command and arguments, run callback function with choice
local function select(callback)
  read_options()

  vim.ui.select(make_cmds[cwd], {
    prompt = "Select commands:",
    format_item = function(option)
      return option.program .. " " .. option.argument
    end,
  }, function(choice)
    if choice and type(callback) == "function" then
      callback(choice)
    end
  end)
end

---
---Set run command and arguments.
---
function M.set_run()
  select(function(choice)
    run_cmd = choice
  end)
end

---
---Set dispatch command and arguments.
---
function M.set_dispatch()
  select(function(choice)
    dispatch_cmd = choice
  end)
end

---
---Edit command cache file.
---
function M.edit()
  vim.cmd("vs " .. file)
end

---
---Add a command to cache file
---
function M.add()
  local function set_make(val, completion, callback)
    local opts = {
      prompt = "Set make " .. val .. ": ",
      completion = completion,
      relative = "editor",
    }
    vim.ui.input(opts, function(input)
      if input then
        new_command[val] = input
        -- sequential for next "ui.input"
        callback()
      end
    end)
  end

  local function write_command()
    table.insert(make_cmds[cwd], new_command)
    write_option()
  end

  read_options()
  set_make("program", "shellcmd", function()
    set_make("argument", "file", write_command)
  end)
end

---
---Run command. Select is called if option is not passed.
---
function M.run(option)
  vim.cmd.wa()
  local cmd = option or run_cmd
  if vim.fn.empty(cmd) == 0 then
    do_with_make(cmd)
  else
    select(function(choice)
      run_cmd = choice
      do_with_make(choice)
    end)
  end
end

---
---Dispatch command. Select is called if option is not passed.
---
function M.dispatch(option)
  -- prefer toggleterm as it's much simpler
  local do_dispatch = do_with_term or do_with_dispatch

  vim.cmd.wa()
  local cmd = option or dispatch_cmd
  if vim.fn.empty(cmd) == 0 then
    do_dispatch(cmd)
  else
    select(function(choice)
      dispatch_cmd = choice
      do_dispatch(choice)
    end)
  end
end

---
---Enable or disable dispatch command on file saved.
---
---@param enable? boolean enable or disable watch
function M.watch(enable)
  local group = "watch_and_dispatch"

  if not enable then
    vim.api.nvim_clear_autocmds({ group = Utils.extra.augroup(group) })
    return
  end

  -- always select a watch command
  select(function(choice)
    watch_cmd = choice
  end)

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = Utils.extra.augroup(group),
    -- TODO: pattern?
    callback = function()
      M.dispatch(watch_cmd)
    end,
  })
end

return M

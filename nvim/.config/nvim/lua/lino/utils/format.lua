---@class Utils.format
local M = {}
local cwd = vim.fn.getcwd()
local file = vim.fn.stdpath("cache") .. "/format_on_save.lua"

-- Init option from global
local format_option = {
  [cwd] = Lino.format_on_save,
}

---Write option to cached file
local function write_option()
  local content = "return " .. vim.inspect(format_option)
  Utils.extra.write_to_file(file, content)
end

---Copy option to global
local function copy_option()
  Lino.format_on_save = vim.tbl_deep_extend("force", Lino.format_on_save, format_option[cwd])
end

---Read option from cached file and copy to global
function M.read_option()
  local f, _ = loadfile(file)
  if f then
    format_option = vim.tbl_deep_extend("force", format_option, f())
  end
  copy_option()
end

---
---Toggle format_on_save for `filetype` in current cwd.
---
--- @param filetype string vim.bo.filetype
--- @return boolean format_on_save on or off
function M.toggle_format_cwd(filetype)
  format_option[cwd][filetype] = not format_option[cwd][filetype]
  copy_option()
  write_option()
  return format_option[cwd][filetype]
end

return M

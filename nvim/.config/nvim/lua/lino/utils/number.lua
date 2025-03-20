---@class Utils.number
local M = {}

local function convert_number(num)
  local formats = { "Dec: %d", "Hex: 0x%x", "Oct: 0o%o", "Bin: 0b%b" }
  local result = {}

  for _, v in ipairs(formats) do
    table.insert(result, vim.fn.printf(v, num))
  end

  return result
end

local function show_in_float(content)
  local success, Popup = pcall(require, "nui.popup")
  if not success then
    print(vim.inspect(content))
    return
  end

  local function find_max_str_length(tbl)
    local maxLength = 30
    for _, str in ipairs(tbl) do
      if #str > maxLength then
        maxLength = #str
      end
    end
    return maxLength
  end
  local max_length = find_max_str_length(content)

  local popup = Popup({
    position = {
      row = 1,
      col = 0,
    },
    size = {
      width = max_length,
      height = #content,
    },
    enter = true,
    focusable = true,
    relative = "cursor",
    border = {
      style = "rounded",
    },
  })

  popup:map("n", "q", function()
    vim.cmd("close")
  end, { noremap = true })

  popup:on("BufLeave", function()
    popup:unmount()
  end, { once = true })

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, content)
  popup:mount()
end

M.show_number = function()
  local numbers = convert_number(vim.fn.expand("<cword>"))
  show_in_float(numbers)
end

return M

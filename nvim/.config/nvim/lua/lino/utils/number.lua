---@class Utils.number
local M = {}

--- Test
-- 0x1234567890abcdef
-- 0xDEADBEAF01234567
-- 0xaa55aa55a
-- 0b0101010101010101010101010101010101010101010101010101010101010101

local function convert_number(num)
  local formats = { "Dec: %d", "Hex: 0x%X", "Oct: 0o%o", "Bin: 0b%b" }
  local result = {}

  for _, v in ipairs(formats) do
    table.insert(result, vim.fn.printf(v, num))
  end

  return result
end

local function group_digits_by_four(lines)
  local function format_line(line)
    local label, value = line:match("^([^:]+:%s)(.+)$")
    if not label then
      return line
    end

    local sign = ""
    if value:sub(1, 1) == "-" then
      sign = "-"
      value = value:sub(2)
    end

    local prefix = ""
    local head2 = value:sub(1, 2)
    if head2 == "0x" or head2 == "0X" or head2 == "0o" or head2 == "0O" or head2 == "0b" or head2 == "0B" then
      prefix = head2
      value = value:sub(3)
    end

    -- strip any existing underscores then group from the left
    value = value:gsub("_", "")
    local grouped
    if #value <= 4 then
      grouped = value
    else
      local parts = {}
      local rem = #value % 4
      local idx = 1
      if rem > 0 then
        table.insert(parts, value:sub(1, rem))
        idx = rem + 1
      end
      for i = idx, #value, 4 do
        table.insert(parts, value:sub(i, i + 3))
      end
      grouped = table.concat(parts, "_")
    end

    return label .. sign .. prefix .. grouped
  end

  local out = {}
  for _, line in ipairs(lines) do
    table.insert(out, format_line(line))
  end
  return out
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
  local grouped = group_digits_by_four(numbers)
  show_in_float(grouped)
end

return M

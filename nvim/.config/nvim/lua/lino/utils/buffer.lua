---@class Utils.buffer
local M = {}

-- Open alpha if current buffer is an empty, unnamed buffer
local function open_alpha_if_empty()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  if not is_empty then
    return
  end

  local ok = pcall(vim.cmd.Alpha)
  if ok then
    -- Close the scratch buffer created by Neovim when last buffer is deleted
    pcall(vim.api.nvim_buf_delete, buf_id, { force = true })
  end
end

--- Delete a buffer using Neovim native API, then show Alpha if last
--- @param buf_id? integer buffer number (defaults to current)
--- @param force? boolean force delete (defaults to false)
function M.delete(buf_id, force)
  buf_id = buf_id or 0
  force = force or false

  -- Use native buffer delete
  pcall(vim.api.nvim_buf_delete, buf_id, { force = force })
  open_alpha_if_empty()
end

--- Close current buffer with save-confirm if modified
function M.remove_buffer()
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      M.delete(0)
    elseif choice == 2 then -- No
      M.delete(0, true)
    end
  else
    M.delete(0)
  end
end

return M

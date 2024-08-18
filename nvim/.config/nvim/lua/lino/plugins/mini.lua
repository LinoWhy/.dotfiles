---Remove anonymous buffer created by mini, open alpha instead
local open_alpha_if_empty = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  if not is_empty then
    return
  end

  local ok, _ = pcall(vim.cmd.Alpha)
  if ok then
    vim.api.nvim_buf_delete(buf_id, { force = true })
  end
end

local function buffer_delete(buf_id, force)
  buf_id = buf_id or 0
  force = force or false
  require("mini.bufremove").delete(buf_id, force)
  open_alpha_if_empty()
end

local function remove_buffer()
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      buffer_delete(0)
    elseif choice == 2 then -- No
      buffer_delete(0, true)
    end
  else
    buffer_delete(0)
  end
end

return {
  {
    "echasnovski/mini.bufremove",
    keys = { { "<leader>c", remove_buffer, desc = "Close Buffer" } },
  },
}

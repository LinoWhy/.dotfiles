---@class Utils.lsp
local M = {}

-- Default LSP keymaps
M.keys = {
  -- stylua: ignore
  -- wrap hover in function, as it's overridden by noice
  ["K"] = { mode = "n", rhs = function() return vim.lsp.buf.hover() end, desc = "Show Hover" },
  ["<leader>lr"] = { mode = "n", rhs = vim.lsp.buf.rename, desc = "Rename" },
}

-- Helper function for keymapping in a buffer
function M.buf_map(bufnr, keys)
  for key, key_opts in pairs(keys) do
    vim.keymap.set(key_opts.mode, key, key_opts.rhs, { buffer = bufnr, desc = key_opts.desc })
  end
end

-- Default LSP on_attach callback
function M.on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(Lino.inlay_hints)
  end

  -- Disable treesitter if semantic token is provided
  if client.server_capabilities.semanticTokensProvider then
    -- vim.treesitter.stop(bufnr)
  end
end

-- Config LSP
function M.config()
  vim.lsp.set_log_level("ERROR")
end

return M

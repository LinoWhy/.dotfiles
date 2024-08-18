---@class Utils.diag
local M = {}

local function set_virtual_text(_, _)
  if Lino.diagnose_virtual_text then
    return { severity = { min = Lino.diagnose_severity_level } }
  else
    return false
  end
end

-- Configs global diagnostic namespace
function M.config()
  vim.diagnostic.config({
    signs = { severity = { min = Lino.diagnose_severity_level } },
    underline = { severity = { min = Lino.diagnose_severity_level } },
    virtual_text = set_virtual_text,
    severity_sort = true,
  })
end

-- Toggle diagnostic virtual text
function M.toggle_diagnostics()
  Lino.diagnose_virtual_text = not Lino.diagnose_virtual_text
  M.config()
end

-- Set minimum diagnostic severity level
function M.set_level(level)
  Lino.diagnose_severity_level = level
  M.config()
end

-- Jump to next diagnostic
function M.next_diagnostic()
  vim.diagnostic.goto_next({ float = not Lino.diagnose_virtual_text, severity = { min = Lino.diagnose_severity_level } })
end

-- Jump to previous diagnostic
function M.prev_diagnostic()
  vim.diagnostic.goto_prev({ float = not Lino.diagnose_virtual_text, severity = { min = Lino.diagnose_severity_level } })
end

return M

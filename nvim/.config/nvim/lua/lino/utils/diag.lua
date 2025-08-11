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
    underline = { severity = { min = Lino.diagnose_severity_level } },
    virtual_text = set_virtual_text,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = Lino.icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = Lino.icons.diagnostics.Warning,
        [vim.diagnostic.severity.HINT] = Lino.icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = Lino.icons.diagnostics.Information,
      },
      texthl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarning",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInformation",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
      severity = { min = Lino.diagnose_severity_level },
    },
    float = { border = "rounded" },
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
  return function()
    Lino.diagnose_severity_level = level
    M.config()
  end
end

-- Jump to next diagnostic
function M.next_diagnostic()
  vim.diagnostic.jump({
    count = 1,
    float = not Lino.diagnose_virtual_text,
    severity = { min = Lino.diagnose_severity_level },
  })
end

-- Jump to previous diagnostic
function M.prev_diagnostic()
  vim.diagnostic.jump({
    count = -1,
    float = not Lino.diagnose_virtual_text,
    severity = { min = Lino.diagnose_severity_level },
  })
end

return M

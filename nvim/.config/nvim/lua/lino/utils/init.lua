-- Use Utils.mod instead of require("lino.utils.mod")
---@class Utils
---@field cmp Utils.cmp
---@field diag Utils.diag
---@field extra Utils.extra
---@field format Utils.format
---@field lsp Utils.lsp
---@field make Utils.make
---@field ui Utils.ui
_G.Utils = setmetatable({}, {
  __index = function(t, k)
    local module = "lino.utils." .. k
    local ok, mod = pcall(require, module)
    if not ok then
      error("module not found: " .. module)
    else
      rawset(t, k, mod)
    end
    return mod
  end,
})

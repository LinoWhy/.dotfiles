require("lino.core.defaults")
if os.getenv("PLUGIN_IN_NEOVIM") then
  require("lino.core.lazy")
end
require("lino.core.options")
require("lino.core.keymaps")
require("lino.core.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local plugins = {
  -- import all submodules
  { import = "lino.plugins" },
  { import = "lino.plugins.lsp.core" },
  { import = "lino.plugins.lsp.lang" },
}

local opts = {
  -- git = { timeout = 1200 }, -- seconds
  install = {
    -- install missing plugins on startup
    missing = true,
    -- load the colorscheme when starting an installation during startup, with fallback
    colorscheme = { Lino.colorscheme, "habamax" },
  },
  ui = { border = "rounded" },
  custom_keys = false, -- disable lazy default key maps
  checker = {
    enabled = false,
    notify = true,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

require("lazy").setup(plugins, opts)

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- load colorscheme after lazy is setup, so colorscheme can be lazy
vim.cmd.colorscheme(Lino.colorscheme)

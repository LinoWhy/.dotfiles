return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      -- PATH = "append", -- set as fallback of system tools
      ui = { border = "rounded" },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "LspInstall", "LspUninstall" },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
  },
}

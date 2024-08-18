return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    keys = { { "<leader>ln", "<cmd>NullLsInfo<cr>", desc = "Null-ls Info" } },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        border = "rounded",
        sources = {
          -- NOTE: null_ls for lint only
          -- null_ls.builtins.diagnostics.luacheck,
          -- null_ls.builtins.diagnostics.selene,
          null_ls.builtins.diagnostics.markdownlint,
        },
        -- HACK: Don't set on_attach directly, may confilct with nvim-lspconfig
        -- Set a callback in lsp on_attach
        -- on_attach = function(client, bufnr)
        -- end,
      })
    end,
  },
}

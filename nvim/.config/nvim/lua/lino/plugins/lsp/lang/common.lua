return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        asm_lsp = {},
        bashls = {},
        -- jdtls = {}, -- java
        dockerls = {},
        jsonls = {},
        lemminx = {}, -- xml
        neocmake = {},
        pyright = {},
        vimls = {},
        yamlls = {},
        marksman = {
          lsp = {
            on_attach = function()
              Utils.diag.set_level(vim.diagnostic.severity.ERROR)()
            end,
          },
        },
      },
    },
  },
}

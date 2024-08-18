return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        bashls = {},
        -- jdtls = {}, -- java
        dockerls = {},
        jsonls = {},
        lemminx = {}, -- xml
        neocmake = {},
        pyright = {},
        vimls = {},
        yamlls = {},
        marksman = {},
      },
    },
  },
}

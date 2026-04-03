return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>ls", "<cmd>LspClangdSwitchSourceHeader <cr>", desc = "Switch Source/Header" },
    },
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          meta = {
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
          },
          lsp = {
            cmd = {
              "clangd",
              "-j=8",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=never", -- or iwyu (include what you use)
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
              "--query-driver=**/**", -- whitelist for clangd to query
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
          },
        },
      },
    },
  },
}

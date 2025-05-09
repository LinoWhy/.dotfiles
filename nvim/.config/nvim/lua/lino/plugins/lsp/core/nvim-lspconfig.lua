return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
  keys = {
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Info" },
  },
  opts = {
    -- Other LSP servers are setup under "lang"
    servers = {
      lua_ls = {
        -- merged with common_keys, key = { mode, rhs, desc }
        -- NOTE: A key with different mode may be overridden
        server_keys = {},
        -- invoked after common_on_attach, nil or function(client, bufnr)
        server_attach = nil,
        -- merged with cmp capabilities
        server_capabilities = {},
        -- server sertup function, nil or functio(server_opts)
        server_setup = nil,
        -- true to skip the default server configuration
        server_skip = false,
        -- Below configs are passed to server.setup(), see lspconfig-setup
        -- on_init settings
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            format = { enable = true },
          },
        },
      },
    },
  },
  config = function(_, opts)
    local common_config = Utils.lsp

    -- -- NOTE: Set rounded border for diagnostic, not handled by noice
    -- vim.diagnostic.config({ float = { border = "rounded" } })

    -- Merge cmp & server configured capabilities
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    -- Setup server
    for server, server_opts in pairs(opts.servers) do
      if server_opts.server_skip then
        goto continue
      end

      -- Invoke common_on_attach first, then server specific callback if configured
      server_opts.on_attach = function(client, bufnr)
        common_config.on_attach(client, bufnr)

        if type(server_opts.server_attach) == "function" then
          server_opts.server_attach()
        end

        -- Merge and setup buffer local keymaps
        local keys = vim.tbl_deep_extend("keep", server_opts.server_keys or {}, common_config.keys)
        common_config.buf_map(bufnr, keys)
      end

      -- NOTE: deepcopy fix some weird behavior with cmp capabilities
      local opt = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, server_opts or {})

      if type(server_opts.server_setup) == "function" then
        server_opts.server_setup(opt)
      else
        require("lspconfig")[server].setup(opt)
      end

      ::continue::
    end

    -- set lspinfo border
    require("lspconfig.ui.windows").default_options.border = "rounded"
  end,
}

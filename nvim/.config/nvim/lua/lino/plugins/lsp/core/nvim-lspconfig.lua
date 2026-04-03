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
        meta = {
          -- merged with common keys, key = { mode, rhs, desc }
          -- NOTE: A key with different mode may be overridden
          keys = {},
          -- merged with cmp capabilities
          capabilities = {},
          -- server setup function, nil or function(lsp_opts)
          setup = nil,
          -- true to skip the default server configuration
          skip = false,
        },
        lsp = {
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
  },
  config = function(_, opts)
    local common_config = Utils.lsp

    -- -- NOTE: Set rounded border for diagnostic, not handled by noice
    -- vim.diagnostic.config({ float = { border = "rounded" } })

    -- Merge cmp & server configured capabilities
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local base_capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    -- Setup server
    for server, server_opts in pairs(opts.servers) do
      local meta = {}
      local lsp_opts = {}

      if next(server_opts or {}) ~= nil then
        if server_opts.meta == nil and server_opts.lsp == nil then
          error(("Invalid LSP config for %s: use {} for defaults or { meta = ..., lsp = ... }"):format(server))
        end
        meta = server_opts.meta or {}
        lsp_opts = vim.tbl_deep_extend("force", {}, server_opts.lsp or {})
      end

      if meta.skip then
        goto continue
      end

      local user_on_attach = lsp_opts.on_attach

      lsp_opts.capabilities = vim.tbl_deep_extend(
        "force",
        vim.deepcopy(base_capabilities),
        lsp_opts.capabilities or {},
        meta.capabilities or {}
      )

      lsp_opts.on_attach = function(client, bufnr)
        common_config.on_attach(client, bufnr)

        if type(user_on_attach) == "function" then
          user_on_attach(client, bufnr)
        end

        -- Merge and setup buffer local keymaps
        local keys = vim.tbl_deep_extend("keep", meta.keys or {}, common_config.keys)
        common_config.buf_map(bufnr, keys)
      end

      if type(meta.setup) == "function" then
        meta.setup(lsp_opts)
      else
        vim.lsp.config(server, lsp_opts)
        vim.lsp.enable(server)
      end

      ::continue::
    end

    -- set lspinfo border
    require("lspconfig.ui.windows").default_options.border = "rounded"
  end,
}

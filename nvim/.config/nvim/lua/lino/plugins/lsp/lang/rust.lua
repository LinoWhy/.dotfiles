return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
      popup = {
        border = "rounded",
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        -- rustaceanvim configures lsp automatically
        on_attach = function(client, bufnr)
          local common_config = Utils.lsp
          common_config.on_attach(client, bufnr)

          local keys = {
            ["<leader>rc"] = { mode = "n", rhs = "<cmd>RustLsp OpenCargo<cr>", desc = "Open Cargo" },
            ["<leader>re"] = { mode = "n", rhs = "<cmd>RustLsp explainError<cr>", desc = "Explain Errors" },
            ["<leader>rd"] = { mode = "n", rhs = "<cmd>RustLsp debuggables<cr>", desc = "Debuggables" },
            ["<leader>rm"] = { mode = "n", rhs = "<cmd>RustLsp expandMacro<cr>", desc = "Expand Macro" },
            ["<leader>rp"] = { mode = "n", rhs = "<cmd>RustLsp parentModule<cr>", desc = "Parent Module" },
            ["<leader>rR"] = { mode = "n", rhs = "<cmd>RustLsp runnables<cr>", desc = "Runnables" },
            ["<leader>rt"] = { mode = "n", rhs = "<cmd>RustLsp testables<cr>", desc = "Testables" },
          }
          keys = vim.tbl_deep_extend("keep", keys, common_config.keys or {})
          common_config.buf_map(bufnr, keys)
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
      tools = {
        float_win_config = { border = "rounded" },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          server_skip = true, -- rustaceanvim configures lsp automatically
        },
        -- toml
        taplo = {
          server_keys = {
            ["K"] = {
              mode = "n",
              rhs = function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Hover",
            },
            ["<leader>rf"] = {
              mode = "n",
              rhs = "<cmd>lua require('crates').show_features_popup()<cr>",
              desc = "[crates] show features",
            },
            ["<leader>rd"] = {
              mode = "n",
              rhs = "<cmd>lua require('crates').show_dependencies_popup()<cr>",
              desc = "[crates] show dependencies",
            },
          },
        },
      },
    },
  },
}

local format_opts = {
  -- async = true,
  lsp_fallback = true,
}

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = Utils.extra.augroup("format_on_save"),
  callback = function()
    local filetype = vim.bo.filetype
    if Lino.format_on_save[filetype] ~= true then
      return
    end

    require("conform").format(format_opts)
  end,
})

return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      "zapling/mason-conform.nvim",
    },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      -- stylua: ignore
      { "<leader>lf", function() require("conform").format(format_opts) end, desc = "Format" },
      { "<leader>lc", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
    },
    opts = {
      formatters_by_ft = {
        cmake = { "gersemi" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" }, -- reads editorconfig
        zsh = { "beautysh" },
      },
      formatters = {
        beautysh = {
          prepend_args = function()
            local indent = tostring(vim.bo.shiftwidth)
            local ret = { "--indent-size", indent }
            if not vim.bo.expandtab then
              table.insert(ret, "--tabs")
            end
            return ret
          end,
        },
        gersemi = {
          prepend_args = function()
            local line_length = tostring(vim.bo.textwidth)
            local indent = vim.bo.expandtab and tostring(vim.bo.shiftwidth) or "tabs"
            return { "--line-length", line_length, "--indent", indent }
          end,
        },
      },
    },
    init = function()
      -- formatexpr (i.e. gq), no opts?
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    lazy = true,
    opts = {},
  },
}

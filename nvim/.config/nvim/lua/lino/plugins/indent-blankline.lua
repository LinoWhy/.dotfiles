return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = {
      char = Lino.icons.ui.LineMiddle,
      tab_char = Lino.icons.ui.LineMiddle,
    },
    whitespace = {
      remove_blankline_trail = false,
    },
    scope = {
      -- enabled = false,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "NvimTree",
        "TelescopePrompt",
        "TelescopeResults",
        "Trouble",
        "alpha",
        "checkhealth",
        "dashboard",
        "gitcommit",
        "help",
        "lazy",
        "lazyterm",
        "lspinfo",
        "man",
        "mason",
        "neo-tree",
        "notify",
        "text",
        "toggleterm",
      },
    },
  },
  -- config = function(_, opts)
  --   require("ibl").setup(opts)

  --   -- continue "indent char" for blank lines, disabled by v3
  --   local hooks = require("ibl.hooks")
  --   local whitespace = require("ibl.indent").whitespace
  --   hooks.register(hooks.type.WHITESPACE, function(_, bufnr, row, whitespace_tbl)
  --     local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  --     if line == "" then
  --       table.insert(whitespace_tbl, whitespace.INDENT)
  --     end
  --     return whitespace_tbl
  --   end)
  -- end,
}

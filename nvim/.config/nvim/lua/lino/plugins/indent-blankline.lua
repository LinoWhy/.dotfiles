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
}

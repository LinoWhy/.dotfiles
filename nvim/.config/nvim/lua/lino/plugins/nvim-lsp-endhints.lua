return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "LspAttach",
  keys = {
    {
      "<leader>te",
      function()
        require("lsp-endhints").toggle()
      end,
      desc = "Toggle End InlayHints",
    },
  },
  opts = {
    icons = {
      type = " ",
      parameter = " ",
    },
    autoEnableHints = false, -- controlled in lsp on_attach
  },
  config = function(_, opts)
    require("lsp-endhints").setup(opts)

    local hl = vim.api.nvim_get_hl(0, { name = "LspInlayHint" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = hl.fg, bg = hl.bg, italic = true })
  end,
}

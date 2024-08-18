return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "LspAttach",
  opts = {
    icons = {
      type = "=> ",
      parameter = "-> ",
    },
    autoEnableHints = false, -- controlled in lsp on_attach
  },
  config = function(_, opts)
    require("lsp-endhints").setup(opts)

    -- remove LspInlayHint background
    local hl = vim.api.nvim_get_hl(0, { name = "LspInlayHint" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = hl.fg })
  end,
}

return {
  {
    "numToStr/Navigator.nvim",
    lazy = true,
    enabled = true,
    keys = {
      { "<C-h>", "<CMD>NavigatorLeft<CR>" },
      { "<C-l>", "<CMD>NavigatorRight<CR>" },
      { "<C-k>", "<CMD>NavigatorUp<CR>" },
      { "<C-j>", "<CMD>NavigatorDown<CR>" },
    },
    opts = {
      disable_on_zoom = true,
    },
  },
}

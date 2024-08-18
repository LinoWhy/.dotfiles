return {
  "ojroques/nvim-osc52",
  keys = {
    {
      "<leader>y",
      function()
        require("osc52").copy_visual()
      end,
      mode = "x",
      desc = "Copy to System Clipboard",
    },
  },
  lazy = true,
}

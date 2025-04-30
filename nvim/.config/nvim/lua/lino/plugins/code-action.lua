return {
  {
    "kosayoda/nvim-lightbulb",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      sign = { enabled = false },
      virtual_text = { enabled = true },
      autocmd = { enabled = true },
    },
  },

  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<leader>la",
        function()
          require("actions-preview").code_actions()
        end,
        desc = "Code Action",
      },
    },
    config = function()
      require("actions-preview").setup({
        telescope = {}, -- use telescope default config
      })
    end,
  },
}

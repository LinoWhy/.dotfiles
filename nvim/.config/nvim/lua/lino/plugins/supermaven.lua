return {
  {
    "supermaven-inc/supermaven-nvim",
    event = { "InsertEnter" },
    opts = {
      keymaps = {
        accept_suggestion = "<C-y>",
        clear_suggestion = "<C-e>",
        accept_word = "<C-n>",
      },
      log_level = "off",
    },
    -- NOTE: hack the suggestion_group highlight, as the plugin doesn't support lazy loading yet
    config = function(_, opts)
      require("supermaven-nvim").setup(opts)

      local preview = require("supermaven-nvim.completion_preview")
      vim.api.nvim_set_hl(0, "SupermavenSuggestion", { fg = "#c6a0f6", italic = true })
      preview.suggestion_group = "SupermavenSuggestion"
    end,
  },
}

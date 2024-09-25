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
  },
}

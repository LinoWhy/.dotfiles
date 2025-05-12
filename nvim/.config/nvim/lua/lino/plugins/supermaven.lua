return {
  {
    "supermaven-inc/supermaven-nvim",
    enabled = Lino.use_ai,
    event = { "InsertEnter" },
    opts = {
      log_level = "off",
      disable_inline_completion = true,
      disable_keymaps = true,
    },
    config = function(_, opts)
      require("supermaven-nvim").setup(opts)

      -- add keymap to accept word completions, other keymaps are managed by nvim-cmp
      local completion_preview = require("supermaven-nvim.completion_preview")
      vim.keymap.set("i", "<A-w>", completion_preview.on_accept_suggestion_word, { noremap = true, silent = true })
    end,
  },
}

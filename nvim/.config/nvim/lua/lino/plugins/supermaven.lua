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
  },
}

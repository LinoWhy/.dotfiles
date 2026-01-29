return {
  {
    "keaising/im-select.nvim",
    enabled = not os.getenv("SSH_CONNECTION"),
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("im_select").setup({
        keep_quiet_on_no_binary = true,
        async_switch_im = false,
      })
    end,
  },
}

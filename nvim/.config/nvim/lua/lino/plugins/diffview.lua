return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewFileHistory", "DiffviewOpen", "DiffviewClose" },
  keys = {
    { "<leader>gf", "<cmd>'<,'>DiffviewFileHistory<cr>", mode = { "v" }, desc = "File (range) History" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    {
      "<leader>gd",
      function()
        local view = require("diffview.lib").get_current_view()
        if view then
          vim.cmd(":DiffviewClose")
        else
          vim.cmd(":DiffviewOpen")
        end
      end,
      desc = "Toggle Diffview",
    },
  },
  opts = {
    view = {
      merge_tool = {
        layout = "diff4_mixed",
      },
    },
  },
}

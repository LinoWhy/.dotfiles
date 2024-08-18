return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufRead", "BufNewFile" },
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    {
      "<leader>sT",
      function() vim.api.nvim_command("TodoTrouble cwd=" .. vim.fn.expand("%:p")) end,
      desc = "Show TODOs in current file",
    },
  },
  opts = {
    signs = true,
    sign_priority = 1, -- lowest priority
    highlight = {
      --multiline = true,
      keyword = "bg",
      after = "",
      -- pattern = [[.*<(KEYWORDS)\s*]], -- match without the extra colon
    },
    search = {
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden", -- hidden for .config
      },
    },
  },
}

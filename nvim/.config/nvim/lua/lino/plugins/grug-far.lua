return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>S",
      function()
        require("grug-far").open()
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
  opts = {
    transient = true,
    prefills = {
      flags = "-F",
    },
  },
}

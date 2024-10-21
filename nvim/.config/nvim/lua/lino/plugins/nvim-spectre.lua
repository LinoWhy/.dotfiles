return {
  "nvim-pack/nvim-spectre",
  enabled = false,
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>S", function() require("spectre").open() end, desc = "Search and Replace" },
    },
}

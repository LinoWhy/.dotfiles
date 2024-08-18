return {
  "mg979/vim-visual-multi",
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    vim.g.VM_theme = "ocean"
    vim.g.VM_default_mappings = 0

    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Prev"] = "<C-p>",
      ["Add Cursor Up"] = "<A-Up>",
      ["Add Cursor Down"] = "<A-Down>",
      ["Skip Region"] = "q",
      ["Remove Region"] = "Q",
    }
  end,
}

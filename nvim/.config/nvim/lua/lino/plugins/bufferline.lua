return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.bufremove",
  },
  event = { "BufRead", "BufNewFile" },
  keys = {
    { "<A-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
    { "<A-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close Others" },
    { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
    { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
    { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
    { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
  },
  opts = {
    options = {
      mode = "buffers", -- set to "tabs" to only show tabpages instead
      numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
      left_mouse_command = "buffer %d",
      right_mouse_command = "vert sbuffer %d",
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      middle_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      indicator = {
        style = "icon", -- can also be 'underline'|'none',
      },
      -- diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "undotree",
          text = "Undotree",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "DiffviewFiles",
          text = "Diff View",
          highlight = "PanelHeading",
          padding = 1,
        },
      },
    },
  },
}

local function replace_quickfix_with_trouble()
  local ok, trouble = pcall(require, "trouble")
  if ok and #vim.fn.getqflist() > 0 then
    vim.defer_fn(function()
      vim.cmd("cclose")
      trouble.open("quickfix")
    end, 0)
  end
end

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = Utils.extra.augroup("replace_quickfix_with_trouble"),
  callback = replace_quickfix_with_trouble,
})

return {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<C-q>",
      function()
        if vim.fn.empty(vim.fn.getqflist()) == 0 then
          vim.cmd([[Trouble quickfix toggle]])
        else
          vim.cmd([[Trouble diagnostics toggle filter.buf=0]])
        end
      end,
      desc = "Toggle Quickfix or Diagnostics",
    },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").previous({ skip_groups = true, jump = true })
        else
          pcall(vim.cmd.cprev)
        end
      end,
      desc = "Previous trouble/quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          pcall(vim.cmd.cnext)
        end
      end,
      desc = "Next trouble/quickfix item",
    },
    {
      "<leader>o",
      "<cmd>Trouble symbols toggle pinned=true results.win.relative=win results.win.position=right focus=true<cr>",
      desc = "Outline",
    },
    {
      "<leader>ll",
      "<cmd>Trouble lsp toggle pinned=true win.position=right focus=false<cr>",
      desc = "Lsp Sidebar",
    },
  },
  opts = {
    focus = true,
    warn_no_results = false,
    win = {
      size = 0.25,
    },
    modes = {
      diagnostics = {
        groups = {
          { "filename", format = "{file_icon} {basename:Title} {count}" },
        },
      },
      cascade_diag = {
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = function(items)
          local severity = vim.diagnostic.severity.HINT
          for _, item in ipairs(items) do
            severity = math.min(severity, item.severity)
          end
          return vim.tbl_filter(function(item)
            return item.severity == severity
          end, items)
        end,
      },
    },
    icons = {
      indent = {
        middle = " ",
        last = " ",
        top = " ",
        ws = "│  ",
      },
    },
  },
}

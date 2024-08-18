return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      -- NOTE: add "relative" in opts passed to vim.ui.input({opts}, {on_confirm}), to control the input position
      get_config = function(opts)
        if opts.relative ~= nil then
          return {
            relative = opts.relative,
          }
        end
      end,
    },
  },
}

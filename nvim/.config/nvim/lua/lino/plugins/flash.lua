return {
  "folke/flash.nvim",
  enabled = false,
  event = { "BufRead", "BufNewFile" },
  -- stylua: ignore
  keys = { { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" } },
  opts = {
    search = {
      mode = function(str)
        return "\\<" .. str -- Match beginning of words only
      end,
    },
    modes = {
      search = {
        -- disable flash search by default, toggle with `require("flash").toggle()`
        enabled = false,
      },
    },
  },
}

local function toggle_signature()
  local manager = require("noice.message.manager")
  local docs = require("noice.lsp.docs")
  local message = docs.get("signature")

  if manager.has(message, { history = true }) then
    docs.hide(message)
  else
    vim.lsp.buf.signature_help()
  end
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    {
      "MunifTanjim/nui.nvim",
      lazy = true,
    },
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        stages = "static",
        render = "wrapped-compact",
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.min(72, math.floor(vim.o.columns * 0.40))
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      },
    },
  },
  -- stylua: ignore
    keys = {
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>ne", function() require("noice").cmd("errors") end, desc = "Noice Errors" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>ns", function() require("noice").cmd("telescope") end, desc = "Search Messages" },
      { "<leader><esc>", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>zt" end end, silent = true, expr = true, desc = "Scroll Forward", mode = { "n", "s"} },
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>zt" end end, silent = true, expr = true, desc = "Scroll Backward", mode = { "n", "s"}},
      { "<c-s>", toggle_signature, mode ={ "i", "s" }, desc = "Hide Signature" },
    },
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
      hover = {
        silent = true, -- set to true to not show a message if hover is not available
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d lines yanked" },
            { find = "%d more lines" },
            { find = "%d fewer lines" },
            { find = "Hunk %d of %d" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "notify",
          warning = true,
          find = "todo comments",
        },
      },
    },
    presets = {
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}

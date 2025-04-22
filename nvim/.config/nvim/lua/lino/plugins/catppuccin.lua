return {
  {
    "catppuccin/nvim",
    lazy = true, -- load during startup
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        term_colors = false,
        dim_inactive = {
          enabled = true,
          shade = "light",
          percentage = 0.5,
        },
        integrations = {
          alpha = true,
          cmp = true,
          diffview = true,
          flash = true,
          gitsigns = true,
          grug_far = true,
          indent_blankline = {
            enabled = true,
            scope_color = "rosewater", -- Default: text
            colored_indent_levels = false,
          },
          illuminate = {
            enabled = true,
            lsp = true,
          },
          lsp_trouble = true,
          mason = true,
          noice = true,
          notify = true,
          nvimtree = true,
          nvim_surround = true,
          semantic_tokens = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
        custom_highlights = function(c)
          local u = require("catppuccin.utils.colors")
          return {
            Macro = { fg = c.sky },
            DiffAdd = { bg = u.darken(c.green, 0.38, c.base) },
            DiffChange = { bg = u.darken(c.blue, 0.27, c.base) },
            DiffDelete = { bg = u.darken(c.red, 0.38, c.base) },
            DiffText = { fg = c.yellow, bg = u.darken(c.blue, 0.50, c.base) },
            CursorLineNr = { fg = c.rosewater, style = { "bold", "italic" } },
            CursorColumn = { bg = c.surface1 },
            CmpItemMenu = { fg = c.rosewater },
            MatchParen = { fg = c.red, bg = "none", style = { "bold" } }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
            -- ["@parameter"] = { fg = c.maroon, style = { "italic" } },
          }
        end,
      })
    end,
  },

  -- integrate bufferline highlights with catppuccin
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      if vim.startswith(Lino.colorscheme, "catppuccin") then
        -- TODO: change highlights after switching colorscheme
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end
    end,
  },
}

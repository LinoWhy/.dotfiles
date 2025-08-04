return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- source for lsp
    "hrsh7th/cmp-cmdline", -- source for cmdline
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" }, -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- luasnip completion source for nvim-cmp
    "rafamadriz/friendly-snippets", -- useful snippets
  },
  config = function()
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    local luasnip = require("luasnip")

    -- set ghost text highlight group
    vim.cmd([[hi MyGhostText cterm=italic gui=italic guibg=#a5adcb guifg=#363a4f]])

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          -- use lua snip engine
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- up
        ["<C-d>"] = cmp.mapping.scroll_docs(4), -- down
        ["<C-q>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- only confirm explicitly selected items
        ["<C-y>"] = {},
        ["<C-e>"] = cmp.mapping.confirm({ select = true }), -- may lead to horizontal scroll by ghost_text & 'wrap' option
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
        { name = "supermaven" }, -- supermaven
        { name = "codeium" }, -- codeium
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
          local icons = Lino.icons

          -- if icons.kind[item.kind] then
          --   -- item.menu = "  (" .. (item.kind or "") .. ")" -- text on the right
          --   -- item.kind = icons[item.kind] -- icon on the left
          -- end
          item.kind = string.format(" %s %s", icons.kind[item.kind] or "", item.kind)

          vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#c6a0f6" })

          local menu = {
            supermaven = icons.misc.Robot,
            buffer = icons.ui.File,
            luasnip = icons.ui.Code,
            nvim_lsp = icons.misc.Server,
            path = icons.misc.Path,
            cmdline = icons.misc.Command,
            avante_commands = icons.misc.Magic,
            avante_mentions = icons.misc.Magic,
            codeium = icons.misc.Magic,
          }
          item.menu = (menu[entry.source.name] or entry.source.name or "") .. " "

          return item
        end,
      },
      sorting = defaults.sorting,
      experimental = { ghost_text = { hl_group = "MyGhostText" } },
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline({
        ["<C-j>"] = { c = cmp.mapping.select_next_item() },
        ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
      }),
      sources = {
        { name = "buffer" },
      },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline({
        ["<C-j>"] = { c = cmp.mapping.select_next_item() },
        ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
      }),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    cmp.event:on("menu_opened", function(event)
      Utils.cmp.add_missing_snippet_docs(event.window)
    end)
  end,
}

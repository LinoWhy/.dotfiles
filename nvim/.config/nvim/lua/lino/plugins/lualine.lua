local icons = Lino.icons

local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > 100
  end,
  hide_in_width_wide = function()
    return vim.o.columns > 160
  end,
}

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local components = {
  branch = {
    "b:gitsigns_head",
    icon = icons.git.Branch,
    color = { gui = "bold" },
  },
  diff = {
    "diff",
    source = diff_source,
    symbols = {
      added = icons.git.LineAdded .. " ",
      modified = icons.git.LineModified .. " ",
      removed = icons.git.LineRemoved .. " ",
    },
    padding = { left = 2, right = 1 },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width_wide,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.diagnostics.BoldError .. " ",
      warn = icons.diagnostics.BoldWarning .. " ",
      info = icons.diagnostics.BoldInformation .. " ",
      hint = icons.diagnostics.BoldHint .. " ",
    },
    -- cond = conditions.hide_in_width,
  },
  lsp = {
    function()
      local clients = vim.lsp.get_clients()
      if #clients == 0 then
        return ""
      end

      -- add client expect null-ls
      local client_names = {}
      for _, cli in pairs(clients) do
        if cli.name ~= "null-ls" then
          table.insert(client_names, cli.name)
        end
      end

      -- add null-ls sources
      local ok_null, null_ls = pcall(require, "null-ls.sources")
      if ok_null then
        local sources = null_ls.get_available(vim.bo.filetype)
        for _, source in ipairs(sources) do
          table.insert(client_names, source.name)
        end
      end

      -- add conform sources
      local ok_conform, conform = pcall(require, "conform")
      if ok_conform then
        local sources = conform.list_formatters_for_buffer()
        for _, source in ipairs(sources) do
          table.insert(client_names, source)
        end
      end

      local names = table.concat(client_names, ", ")
      return string.format("[%s]", names)
    end,
    -- color = { gui = "bold" },
    cond = conditions.hide_in_width_wide,
  },
  progress = {
    function()
      local cur = vim.fn.line(".")
      local total = vim.fn.line("$")
      return string.format("%3d%%%%", math.floor(cur / total * 100))
    end,
    padding = { left = 1, right = 1 },
    color = {},
    cond = nil,
  },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  encoding = {
    "o:encoding",
    fmt = string.upper,
    color = {},
    cond = conditions.hide_in_width_wide,
  },
  sep = { "%=" },
  filename = { "filename", path = 1, cond = conditions.hide_in_width, color = { gui = "italic" } },
  filetype = { "filetype", cond = conditions.hide_in_width_wide, padding = { left = 1, right = 1 } },
  filesize = { "filesize", color = {}, cond = conditions.hide_in_width_wide },
  -- stylua: ignore
  recording = {
    function() return require("noice").api.status.mode.get() end,
    cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
    color = { fg = "#f5a97f" },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local lualine = require("lualine")

    lualine.setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { components.branch },
        lualine_c = {
          components.diff,
          components.diagnostics,
          -- components.treesitter,
          components.lsp,
          components.recording,
          components.sep,
          components.filename,
        },
        lualine_x = { "fileformat", components.spaces, components.filetype, components.encoding, components.filesize },
        lualine_y = { "location" },
        lualine_z = { components.progress },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}

local ignored_languages = {}

local function make_textobject_keymaps()
  local function select_textobject(query)
    return function()
      require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end
  end
  local function move_textobject(method, query)
    return function()
      require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
    end
  end
  local function swap_textobject(method, query)
    return function()
      require("nvim-treesitter-textobjects.swap")[method](query)
    end
  end

  local select_specs = {
    { "ac", "@class.outer", "Select Around Class" },
    { "ic", "@class.inner", "Select Inside Class" },
    { "af", "@function.outer", "Select Around Function" },
    { "if", "@function.inner", "Select Inside Function" },
  }
  local move_specs = {
    { "]f", "goto_next_start", "@function.outer", "Next Function Start" },
    { "]a", "goto_next_start", "@parameter.inner", "Next Parameter Start" },
    { "]C", "goto_next_start", "@class.outer", "Next Class Start" },
    { "]F", "goto_next_end", "@function.outer", "Next Function End" },
    { "]A", "goto_next_end", "@parameter.inner", "Next Parameter End" },
    { "[f", "goto_previous_start", "@function.outer", "Previous Function Start" },
    { "[a", "goto_previous_start", "@parameter.inner", "Previous Parameter Start" },
    { "[C", "goto_previous_start", "@class.outer", "Previous Class Start" },
    { "[F", "goto_previous_end", "@function.outer", "Previous Function End" },
    { "[A", "goto_previous_end", "@parameter.inner", "Previous Parameter End" },
  }
  local swap_specs = {
    { ">F", "swap_next", "@function.outer", "Swap Next Function" },
    { ">A", "swap_next", "@parameter.inner", "Swap Next Parameter" },
    { "<F", "swap_previous", "@function.outer", "Swap Previous Function" },
    { "<A", "swap_previous", "@parameter.inner", "Swap Previous Parameter" },
  }

  local keymaps = {}
  for _, spec in ipairs(select_specs) do
    keymaps[#keymaps + 1] = {
      spec[1],
      select_textobject(spec[2]),
      mode = { "x", "o" },
      desc = spec[3],
    }
  end

  for _, spec in ipairs(move_specs) do
    keymaps[#keymaps + 1] = {
      spec[1],
      move_textobject(spec[2], spec[3]),
      mode = { "n", "x", "o" },
      desc = spec[4],
    }
  end

  for _, spec in ipairs(swap_specs) do
    keymaps[#keymaps + 1] = {
      spec[1],
      swap_textobject(spec[2], spec[3]),
      desc = spec[4],
    }
  end

  return keymaps
end

local function setup_treesitter()
  local ts = require("nvim-treesitter")
  local available_languages = {}
  local install_pending = {}

  for _, language in ipairs(ts.get_available()) do
    available_languages[language] = true
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("lino_treesitter_main", { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].buftype ~= "" then
        return
      end

      local filetype = vim.bo[event.buf].filetype
      local language = vim.treesitter.language.get_lang(filetype) or filetype
      if not language or ignored_languages[language] or not available_languages[language] then
        return
      end

      if not vim.list_contains(ts.get_installed(), language) and not install_pending[language] then
        install_pending[language] = true
        ts.install(language, { summary = true })
      end

      if pcall(vim.treesitter.start, event.buf, language) then
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false, -- last release is way too old and doesn't work on Windows
    lazy = false,
    build = function()
      require("nvim-treesitter").update():wait(120000) -- max. 2 minutes
    end,
    config = function()
      setup_treesitter()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = make_textobject_keymaps(),
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = true,
        },
        move = {
          set_jumps = true,
        },
      })
    end,
  },

  {
    "romgrk/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "[x",
        function()
          require("treesitter-context").go_to_context()
        end,
        desc = "Jump to Context",
      },
    },
    opts = {
      mode = "cursor",
      max_lines = 4,
    },
  },
}

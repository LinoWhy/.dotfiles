return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdateSync",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "v", desc = "Increment Selection", mode = "x" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      auto_install = true,
      ignore_install = { "tmux" },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = false,
          node_incremental = "v",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
          -- to act similarly to eg the built-in `ap`.
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[A"] = "@parameter.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">F"] = "@function.outer",
            [">A"] = "@parameter.inner",
          },
          swap_previous = {
            ["<F"] = "@function.outer",
            ["<A"] = "@parameter.inner",
          },
        },
      },
      matchup = {
        enable = true,
        disable_virtual_text = true, -- highlight end of a block
        include_match_words = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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

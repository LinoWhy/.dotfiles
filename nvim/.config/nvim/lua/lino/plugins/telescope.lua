local function find_project_files()
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files)
  if not ok then
    builtin.find_files()
  end
end

local function grep_word_under_cursor()
  require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
end

local keys = {
  { "<leader>f", find_project_files, desc = "Find Files" },
  -- g
  { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
  { "ga", "<cmd>split<cr><cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition (split)" },
  { "gs", "<cmd>vsplit<cr><cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition (vsplit)" },
  { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Goto Reference" },
  { "gC", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Goto Caller" },
  { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
  { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
  -- <leader>b
  { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
  -- <leader>g
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout Branch" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout Commit" },
  { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout Commit (for current file)" },
  { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
  -- <leader>l
  { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },
  { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
  -- <leader>s
  { "<leader>sb", "<cmd>Telescope builtin<cr>", desc = "Telescope Builtin" },
  { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Find Commands" },
  { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
  {
    "<leader>sf",
    "<cmd>Telescope find_files find_command=fd,--no-ignore,--hidden<cr>",
    desc = "Find All Files",
  },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Helps" },
  { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find Highlights" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Find Keymaps" },
  { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
  { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undos" },
  { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>sw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  { "<leader>sW", grep_word_under_cursor, desc = "Grep Current Word" },
  { "<leader>sg", '<cmd>Telescope live_grep search_dirs={"%"}<cr>', desc = "Grep Text Locally" },
  -- stylua: ignore
  { "<leader>st", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Grep with args", },
  -- stylua: ignore
  { "<leader>sm", function() require("telescope.builtin").man_pages({ sections = { "ALL" } }) end, desc = "Man Pages", },
}

local layout_config = {
  height = 0.8,
  width = 0.8,
  bottom_pane = { height = 25, preview_cutoff = 120 },
  center = { height = 0.4, preview_cutoff = 45, width = 0.5 },
  cursor = { preview_cutoff = 45 },
  flex = { flip_columns = 150 },
  horizontal = { preview_cutoff = 120, preview_width = 0.45 },
  vertical = {
    preview_cutoff = 45,
    width = function(_, max_columns, _)
      return math.min(max_columns, math.max(math.floor(max_columns * 0.5), 80))
    end,
  },
}

local file_ignore_patterns = {
  "%.o",
  "%.gz",
  "%.tar",
  "%.3",
  "%.4",
  "%.5",
  "%.6",
  "%.7",
  "%.8",
  "%.9",
  "%.jpg",
  "%.jpeg",
  "%.png",
  "%.svg",
  "%.otf",
  "%.ttf",
  "%.idx",
  "^%.git/",
  "^%.repo/",
  "^%.github/",
  "^%.cache/",
}

local function pickers(actions)
  return {
    lsp_references = { fname_width = 45, show_line = false },
    lsp_incoming_calls = { fname_width = 45, show_line = false },
    lsp_outgoing_calls = { fname_width = 45, show_line = false },
    lsp_definitions = { fname_width = 45, show_line = false },
    lsp_type_definitions = { fname_width = 45, show_line = false },
    lsp_implementations = { fname_width = 45, show_line = false },
    lsp_document_symbols = { fname_width = 45, symbol_width = 30, show_line = false },
    lsp_workspace_symbols = { fname_width = 45, symbol_width = 30, show_line = false },
    lsp_dynamic_workspace_symbols = { fname_width = 45, symbol_width = 30, show_line = false },
    live_grep = { only_sort_text = true },
    grep_string = { only_sort_text = true },
    buffers = { mappings = { n = { ["dd"] = actions.delete_buffer + actions.move_to_top } } },
    git_files = { show_untracked = true },
  }
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
    "debugloop/telescope-undo.nvim",
  },
  keys = keys, -- lazy load on the keymaps
  opts = {
    defaults = {
      layout_config = layout_config,
      layout_strategy = "vertical",
      path_display = { filename_first = { reverse_directories = false } },
      preview = { timeout = 150 },
      prompt_prefix = Lino.icons.ui.Telescope .. " ",
      selection_caret = Lino.icons.ui.Forward .. " ",
      file_ignore_patterns = file_ignore_patterns,
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      undo = {
        use_delta = true,
        side_by_side = true,
        layout_config = {
          width = 0.8,
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local function send_to_qflist_and_open_trouble(prompt_bufnr)
      actions.smart_send_to_qflist(prompt_bufnr)
      local ok, trouble = pcall(require, "trouble")
      if ok then
        trouble.open("quickfix")
      else
        actions.open_qflist(prompt_bufnr)
      end
    end

    opts.defaults.mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-x>"] = false,
        ["<C-f>"] = actions.to_fuzzy_refine,
        ["<C-q>"] = send_to_qflist_and_open_trouble,
      },
      n = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-x>"] = false,
        ["<C-f>"] = actions.to_fuzzy_refine,
        ["<C-q>"] = send_to_qflist_and_open_trouble,
      },
    }

    opts.pickers = pickers(actions)

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
    telescope.load_extension("undo")
  end,
}
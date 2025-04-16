local function find_project_files()
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files)
  if not ok then
    builtin.find_files()
  end
end

local keys = {
  { "<leader>f", find_project_files, desc = "Find Files" },
  -- g
  { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
  { "gs", "<cmd>split<cr><cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition (split)" },
  { "ga", "<cmd>vsplit<cr><cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition (vsplit)" },
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
  { "<leader>sf", "<cmd>Telescope find_files find_command=fd,-I,-H,-tf<cr>", desc = "Find All Files" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Helps" },
  { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find Highlights" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Find Keymaps" },
  { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
  { "<leader>sm", "<cmd>Telescope man_pages sections=ALL<cr>", desc = "Man Pages" },
  { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
  { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  -- Symbols
  { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>sw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  -- grep
  { "<leader>st", "<cmd>Telescope live_grep_args<cr>", desc = "Grep with args" },
  { "<leader>sg", '<cmd>Telescope live_grep search_dirs={"%"}<cr>', desc = "Grep Locally" },
  {
    "<leader>sW",
    function()
      require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
    end,
    desc = "Grep Current Word",
  },
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

local open_selected = function(prompt_bufnr)
  local actions = require("telescope.actions")
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local selected = picker:get_multi_selection()
  if vim.tbl_isempty(selected) then
    actions.select_default(prompt_bufnr)
  else
    actions.close(prompt_bufnr)
    for _, file in pairs(selected) do
      vim.cmd.badd(file.path)
    end
    vim.cmd.edit(selected[1].path)
  end
end

local multi_open_mapping = { n = { ["<CR>"] = open_selected }, i = { ["<CR>"] = open_selected } }

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
    git_files = { show_untracked = true, mappings = multi_open_mapping },
    find_files = { mappings = multi_open_mapping },
    oldfiles = { mappings = multi_open_mapping },
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
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")

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

    opts.extensions.live_grep_args = {
      auto_quoting = false,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
        },
      },
    }

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
}

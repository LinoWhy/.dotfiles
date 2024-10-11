local icons = Lino.icons

local start_telescope = function(telescope_mode)
  local node = require("nvim-tree.lib").get_node_at_cursor()
  if node == nil then
    return
  end

  local abspath = node.link_to or node.absolute_path
  local is_folder = node.open ~= nil
  local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
  require("telescope.builtin")[telescope_mode]({
    cwd = basedir,
  })
end

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "gf", function()
    start_telescope("find_files")
  end, opts("Find Files"))
  vim.keymap.set("n", "gt", function()
    start_telescope("live_grep")
  end, opts("Live grep"))
end

local function float_config()
  local HEIGHT_RATIO = 0.8
  local WIDTH_RATIO = 0.5
  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local window_w = screen_w * WIDTH_RATIO
  local window_h = screen_h * HEIGHT_RATIO
  local window_w_int = math.floor(window_w)
  local window_h_int = math.floor(window_h)
  local center_x = (screen_w - window_w) / 2
  local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

  return {
    relative = "editor",
    border = "rounded",
    width = window_w_int,
    height = window_h_int,
    row = center_y,
    col = center_x,
  }
end

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
  -- event = { "BufRead", "BufNewFile" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  },
  init = function()
    -- disable netrw at the very start
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- enable "nvim ."
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("nvim-tree")
      end
    end
  end,
  opts = {
    on_attach = on_attach,
    auto_reload_on_write = true,
    sync_root_with_cwd = true,
    view = {
      centralize_selection = true,
      float = {
        enable = true,
        quit_on_focus_loss = false,
        open_win_config = float_config,
      },
      -- width = {
      --   min = 30,
      --   max = -1, -- unlimited
      -- },
    },
    renderer = {
      highlight_git = true,
      root_folder_label = ":t",
      icons = {
        webdev_colors = true,
        git_placement = "after",
        glyphs = {
          default = icons.ui.Text,
          symlink = icons.ui.FileSymlink,
          bookmark = icons.ui.BookMark,
          folder = {
            arrow_closed = icons.ui.TriangleShortArrowRight,
            arrow_open = icons.ui.TriangleShortArrowDown,
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderOpen,
          },
          git = {
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            unmerged = icons.git.FileUnmerged,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            deleted = icons.git.FileDeleted,
            ignored = icons.git.FileIgnored,
          },
        },
      },
    },
    -- hijack_directories = {
    --   enable = false,
    --   auto_open = true,
    -- },
    update_focused_file = {
      enable = true,
      update_root = {
        enable = true,
        ignore_list = {},
      },
    },
    diagnostics = {
      enable = false,
      icons = {
        hint = icons.diagnostics.BoldHint,
        info = icons.diagnostics.BoldInformation,
        warning = icons.diagnostics.BoldWarning,
        error = icons.diagnostics.BoldError,
      },
    },
    git = {
      enable = false,
      timeout = 200,
    },
    actions = {
      change_dir = { enable = false },
      open_file = {
        quit_on_open = true,
        window_picker = {
          enable = true,
          picker = "default",
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
    trash = {
      cmd = "trash",
      require_confirm = true,
    },
  },
}

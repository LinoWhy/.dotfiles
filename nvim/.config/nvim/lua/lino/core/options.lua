local opt = vim.opt

-- system
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.confirm = true
-- opt.fileencoding = "utf-8" -- the encoding written to a file
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.swapfile = false -- no swapfile
opt.undofile = true -- enable persistent undo
opt.updatetime = 100 -- faster completion, also for CursorHold autocommand event
opt.jumpoptions = "stack"
opt.inccommand = "split"

-- appearance
opt.cursorline = true -- highlight the current line
opt.laststatus = 3 -- always and ONLY the last window
opt.showcmd = false -- controlled by statusline
opt.showmode = false -- controlled by statusline
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.title = false -- leave title to be handled by terminal
-- opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.pumheight = 15 -- maximum popup menu height
opt.pumwidth = 15 -- minimum popup menu width
opt.winminwidth = 5 -- hard minimum window width
opt.winborder = "rounded" -- default border style of floating windows

-- line & column
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.scrolloff = 15 -- minimal number of screen lines to keep above and below the cursor.
opt.sidescrolloff = 8 -- minimal number of screen lines to keep left and right of the cursor.
opt.smoothscroll = true -- scroll by screen line rather than by text line
opt.statuscolumn = [[%!v:lua.Utils.ui.statuscolumn()]]

-- tabs & indentation
-- NOTE: may be overwritten by ftplugin & editorconfig
opt.tabstop = 8 -- default 8
opt.shiftwidth = 4 -- spaces for <<, >>
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.textwidth = 80 -- overridden by "max_line_length" in editorconfig
opt.colorcolumn = "+0" -- set colorcolumn as textwidth

-- show whitespace
opt.list = true
opt.listchars:append("tab:▸-")
opt.listchars:append("space:⋅")
opt.listchars:append("lead:⋅") -- ⋅🞄⚬
opt.listchars:append("trail:●")
opt.listchars:append("extends:>")
opt.listchars:append("precedes:<")

-- fold
opt.foldmethod = "indent"
opt.foldlevelstart = 99

-- search
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true -- smart case

-- reading & coding related
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
opt.completeopt = { "menuone", "preview", "noselect" }
opt.matchtime = 3
opt.showmatch = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = false

if vim.env.SSH_CONNECTION and not vim.env.TMUX then
  vim.g.clipboard = "osc52"
end

Utils.lsp.config()
Utils.diag.config()

-- neovide options
if vim.g.neovide then
  opt.guifont = { "Recursive Mono Casual Static Freeze", "Cascadia Code", "Symbols Nerd Font Mono", ":h10.5" }
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
end

-- default opts is { expr = false, remap = false }
local map = vim.keymap.set

-- better up & down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- begin & end of line
map({ "n", "x" }, "gh", "^", { desc = "Go to the start of the line" })
map({ "n", "x" }, "gl", "$", { desc = "Go to the end of the line" })

-- Move to window using the <ctrl> hjkl keys
if not Utils.extra.has("Navigator.nvim") then
  map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
  map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
  map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
  map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
  map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
  map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
  map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
  map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
end

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<leader>m", function()
  local width = vim.o.textwidth + Lino.extra_width
  if vim.fn.winwidth(0) < width then
    vim.api.nvim_win_set_width(0, width)
  end
end, { desc = "Adjust window" })

-- Move Lines
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })

-- Tabs
map("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>n", "<cmd>tabnew %<cr>", { desc = "New Tab" })
map("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- NOTE: partially handled by noice
-- center scroll, jump & search
map("n", "<C-d>", "<C-d>zt")
map("n", "<C-u>", "<C-u>zt")
map("n", "<C-f>", "<C-f>zt")
map("n", "<C-b>", "<C-b>zt")
map("n", "<C-i>", "<C-i>zt")
map("n", "<C-o>", "<C-o>zt")
map("n", "n", "nzt")
map("n", "N", "Nzt")
map("n", "<C-e>", "3<C-e>")
map("n", "<C-y>", "3<C-y>")

-- Clear highlight with <esc>
map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>")

-- Change text with different registers
map({ "n", "x" }, "x", '"xx')
map({ "n", "x" }, "X", '"xX')
map({ "n", "x" }, "<Del>", '"xx')
map({ "n", "x" }, "c", '"cc')
map({ "n", "x" }, "C", '"cC')
map({ "n", "x" }, "d", '"dd')
map({ "n", "x" }, "D", '"dD')
map("x", "P", "p") -- swap yanked text with register via "P" in visual_block_mode
map("x", "p", "P")

-- Reselect visual area after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- Reselect visual area with 'gV', 'gv' would be remapped
map("n", "gV", "gv")

-- % to \
map({ "n", "x" }, "\\", "%")

-- Some common keys
map("n", "<leader>w", "<cmd>w!<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>x", Utils.extra.execute_current_file, { desc = "Execute" })
map("i", "<C-l>", "<End>")

-- Sudo write file
-- NOTE: install ssh-askpass-gnome manually!
map("n", "<leader>W", function()
  vim.cmd([[silent w !SUDO_ASKPASS=`which ssh-askpass` sudo tee % >/dev/null]])
end, { desc = "Save with sudo" })

-- Terminal
map("t", "<C-q>", [[<C-\><C-n>]])
-- Clean scrollback & clear
function _G.ClearTerm()
  vim.opt.scrollback = 1

  vim.api.nvim_command("startinsert")
  vim.api.nvim_feedkeys("clear", "t", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "t", true)

  vim.opt.scrollback = -1
end

map("t", "<M-l>", [[<C-\><C-N>:lua ClearTerm()<CR>]], { desc = "Clear Terminal", silent = true })

-- Diagnostics
map("n", "]d", Utils.diag.next_diagnostic, { desc = "Next Diagnostic" })
map("n", "[d", Utils.diag.prev_diagnostic, { desc = "Prev Diagnostic" })
map("n", "<leader>lj", Utils.diag.next_diagnostic, { desc = "Next Diagnostic" })
map("n", "<leader>lk", Utils.diag.prev_diagnostic, { desc = "Prev Diagnostic" })
map("n", "<leader>l1", function()
  Utils.diag.set_level(vim.diagnostic.severity.ERROR)
end, { desc = "Severity Level Error" })
map("n", "<leader>l2", function()
  Utils.diag.set_level(vim.diagnostic.severity.WARN)
end, { desc = "Severity Level Warn" })
map("n", "<leader>l3", function()
  Utils.diag.set_level(vim.diagnostic.severity.INFO)
end, { desc = "Severity Level Info" })
map("n", "<leader>l4", function()
  Utils.diag.set_level(vim.diagnostic.severity.HINT)
end, { desc = "Severity Level Hint" })

-- Toggle options
local function toggle_option(option, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
  else
    vim.opt_local[option] = not vim.opt_local[option]:get()
  end
  -- show option result
  vim.cmd("set " .. option .. "?")
end

-- stylua: ignore
map("n", "<leader>tc", function() toggle_option("cursorcolumn") end, { desc = "Toggle Cursor Column" })
-- stylua: ignore
map("n", "<leader>ts", function() toggle_option("spell") end, { desc = "Toggle Spell" })
-- stylua: ignore
map("n", "<leader>tw", function() toggle_option("wrap") end, { desc = "Toggle Word Wrap" })
-- stylua: ignore
map("n", "<leader>tz", function() toggle_option("foldmethod", {"indent", "manual"}) end, { desc = "Toggle Fold Method" })

-- toggle diagnose text
map("n", "<leader>td", function()
  Utils.diag.toggle_diagnostics()
  if Lino.diagnose_virtual_text then
    print("show diagnostics virtual text")
  else
    print("hide diagnostics virtual text")
  end
end, { desc = "Toggle Diagnose Text" })

-- toggle formatting on save
map("n", "<leader>tf", function()
  local filetype = vim.bo.filetype
  Lino.format_on_save[filetype] = not Lino.format_on_save[filetype]
  if Lino.format_on_save[filetype] then
    print("format_on_save for [" .. filetype .. "]")
  else
    print("not format_on_save for [" .. filetype .. "]")
  end
end, { desc = "Toggle Format on Save" })

-- toggle formatting on save (cwd)
map("n", "<leader>tF", function()
  local filetype = vim.bo.filetype
  local cwd = vim.fn.getcwd()
  local ret = Utils.format.toggle_format_cwd(filetype)
  if ret then
    print("format_on_save for [" .. filetype .. "] in: " .. cwd)
  else
    print("not format_on_save for [" .. filetype .. "] in: " .. cwd)
  end
end, { desc = "Toggle Format on Save (cwd)" })
-- read cached options
Utils.format.read_option()

-- toggle inlay_hints
map("n", "<leader>ti", function()
  -- toggle global setting, used by lsp "common_on_attach"
  Lino.inlay_hints = not Lino.inlay_hints
  -- toggle for existing buffers
  vim.lsp.inlay_hint.enable(Lino.inlay_hints)
end, { desc = "Toggle inlay_hint" })

-- Set and run vim "make"
map("n", "<leader>ra", Utils.make.add, { desc = "Add command" })
map("n", "<leader>re", Utils.make.edit, { desc = "Edit commands" })
map("n", "<leader>rs", Utils.make.set_run, { desc = "Set run command" })
map("n", "<leader>rS", Utils.make.set_dispatch, { desc = "Set dispatch command" })
map("n", "<leader>rr", Utils.make.run, { desc = "Run command" })
map("n", "<leader>rd", Utils.make.dispatch, { desc = "Dispatch command" })
map("n", "<leader>rw", function()
  Lino.watch_and_dispatch = not Lino.watch_and_dispatch
  Utils.make.watch(Lino.watch_and_dispatch)
  if Lino.watch_and_dispatch then
    print("Enable dispatch on file save")
  else
    print("Disable dispatch on file save")
  end
end, { desc = "Watch & Dispatch" })

-- dec2hex the word under the cursor
map("n", "<leader>N", Utils.number.show_number, { desc = "Show Number", silent = true })

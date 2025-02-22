-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = Utils.extra.augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Search" })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = Utils.extra.augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- not list buffer for some filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = Utils.extra.augroup("no_buffer"),
  pattern = {
    "alpha",
    "dap-repl",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = Utils.extra.augroup("close_with_q"),
  pattern = {
    "Avante*",
    "DressingSelect",
    "PlenaryTestPopup",
    "checkhealth",
    "dap-float",
    "dapui_hover",
    "floaterm",
    "gitsigns-*",
    "grug-far*",
    "help",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "null-ls-info",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- set colorcolumn according to textwidth
vim.api.nvim_create_autocmd("BufEnter", {
  group = Utils.extra.augroup("set_cc"),
  callback = function()
    local tw = vim.opt.textwidth:get()
    if tw ~= 0 then
      vim.cmd("setlocal cc=" .. tostring(tw))
    end
  end,
})

-- change window scrolloff
vim.api.nvim_create_autocmd({ "WinNew", "VimResized", "WinResized" }, {
  group = Utils.extra.augroup("set_scrolloff"),
  callback = function()
    local window_height = vim.api.nvim_win_get_height(0)
    local golden_ratio = 0.25
    vim.wo.scrolloff = math.floor(window_height * golden_ratio)
  end,
})

-- report on DirChanged
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = Utils.extra.augroup("dir_changed"),
  callback = function()
    vim.print("CWD:")
    vim.cmd([[pwd]])
  end,
})

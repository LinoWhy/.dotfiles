vim.cmd("setlocal nolist")
vim.cmd("setlocal wrap")
vim.cmd("setlocal spell")
vim.cmd("setlocal spelllang=en_us,cjk")

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"

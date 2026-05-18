vim.cmd("setlocal wrap")
vim.cmd("setlocal spell")
vim.cmd("setlocal spelllang=en_us,cjk")

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

if not vim.g.markdown_list_on_insert_autocmd then
  vim.g.markdown_list_on_insert_autocmd = true

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = Utils.extra.augroup("markdown_list_on_insert"),
    callback = function(event)
      if vim.bo[event.buf].filetype ~= "markdown" then
        return
      end

      vim.opt_local.list = event.event == "InsertEnter"
    end,
  })
end

-- Update fold after treesitter is setup
vim.schedule(function()
  vim.cmd("silent! normal! zx")
  vim.cmd("SatelliteDisable")
end)

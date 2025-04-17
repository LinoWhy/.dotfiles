-- EditorConfig is evaluated by neovim after 'ftplugins' and 'FileType' autocommands.
-- So the below settings will be overridden.
-- However, 'max_line_lengtheditorconfig' is not a default option in EditorConfig, but supported by neovim. This will
-- sets the 'textwidth' and therefore 'colorcoumn'. So only set a default value here.
vim.cmd("setlocal textwidth=80")

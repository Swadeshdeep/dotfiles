-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true

--for rust in lazy.extras
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

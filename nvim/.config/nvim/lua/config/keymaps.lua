-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- Change Theme (Themery)
map("n", "<leader>th", "<cmd>Themery<cr>", { desc = "Change Theme" })
map("n", "<leader>te", "<cmd>TransparentEnable<cr>", { desc = "Enable Transparent" })
map("n", "<leader>td", "<cmd>TransparentDisable<cr>", { desc = "Desable Transparent" })
-- Competitive programming
map("n", "<leader>tg", "<cmd>CompetiTest receive problem<cr>", { desc = "Get cp code" })
map("n", "<leader>tr", "<cmd>CompetiTest run<cr>", { desc = "Run test" })
-- for changing theme
map("n", "<leader>tk", "<cmd>colorscheme gruvbox-material<cr>", { desc = "Switch to gruvbox-material theme" })
map("n", "<leader>tl", "<cmd>colorscheme tokyonight-night<cr>", { desc = "Switch to tokyonight-night theme" })

-- Keymaps for yazi file manager
map("n", "<leader>fy", "<cmd>Yazi toggle<cr>", { desc = "Yazi Toggle" })

-- for mini.files(oil+neotree)
map("n", "<leader>fm", "<cmd>lua MiniFiles.open()<cr>", { desc = "mini.files" })

-- for oil.nvim
map("n", "<leader>o", "<cmd>Oil --float<cr>", { desc = "Oil.nvim" })

-- for changing the use of d key
map({ "n", "v" }, "d", '"_d', { noremap = true })
map("n", "x", '"_x', { noremap = true }) -- for visual char-wise delete

-- for diffview in neovim
map("n", "<leader>gv", "<cmd>DiffviewFileHistory<cr>", { desc = "Change Theme" })

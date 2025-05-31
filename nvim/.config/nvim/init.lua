-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.code-runner")
require("config.code-runner2")

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = "/home/swadesh/programming/cp/*.cpp",
  command = "0r ~/.config/nvim/cpp_template.txt",
})

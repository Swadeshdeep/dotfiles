return {
  "echasnovski/mini.nvim",
  require("mini.files").setup({
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = false,
      -- Whether to use for editing directories
      use_as_default_explorer = false,
    },
  }),
  require("mini.move").setup({}),
}

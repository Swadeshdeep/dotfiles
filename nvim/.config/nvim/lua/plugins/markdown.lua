return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      code = {
        sign = true,
        width = "full",
        right_pad = 0,
      },
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      checkbox = {
        enabled = true,
      },
    },
  },
  -- {
  --   "nvim-orgmode/orgmode",
  --   event = "VeryLazy",
  --   config = function()
  --     -- Setup orgmode
  --     require("orgmode").setup({
  --       org_agenda_files = "~/sync/agenda.org",
  --       org_default_notes_file = "~/sync/test.org",
  --     })
  --   end,
  -- },
  -- {
  --   "akinsho/org-bullets.nvim",
  --   config = function()
  --     require("org-bullets").setup()
  --   end,
  -- },
  -- -- init.lua
  -- {
  --   "chipsenkbeil/org-roam.nvim",
  --   config = function()
  --     require("org-roam").setup({
  --       directory = "~/org_roam_files",
  --       -- optional
  --       org_files = {
  --         "~/sync/agenda.org",
  --         "~/sync/test.org",
  --       },
  --     })
  --   end,
  -- },
}

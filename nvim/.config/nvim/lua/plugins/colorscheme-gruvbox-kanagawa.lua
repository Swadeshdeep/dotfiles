return {
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_foreground = "original"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
    end,
  },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   opts = {
  --     theme = "wave", -- Use "dragon" or "lotus" if you prefer
  --     background = { dark = "wave", light = "lotus" }, -- Ensures correct theme is set
  --   },
  --   config = function()
  --     require("kanagawa").setup({
  --       transparent = true, -- Some versions support this, but if not, use the method below
  --     })
  --
  --     -- Manually set transparency for full effect
  --     vim.cmd([[
  --     hi Normal guibg=NONE ctermbg=NONE
  --     hi NormalNC guibg=NONE ctermbg=NONE
  --     hi EndOfBuffer guibg=NONE ctermbg=NONE
  --     hi SignColumn guibg=NONE ctermbg=NONE
  --     hi Folded guibg=NONE ctermbg=NONE
  --     hi StatusLine guibg=NONE ctermbg=NONE
  --   ]])
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },
  {
    {
      "folke/tokyonight.nvim",
      opts = function(_, opts)
        opts.style = "night"
        opts.styles = {
          functions = {},
        }
        opts.on_colors = function(colors)
          colors.fg = "#DCD7BA"
        end
      end,
    },
  },
}

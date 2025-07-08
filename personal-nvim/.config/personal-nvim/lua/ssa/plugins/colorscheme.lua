return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme tokyonight-night")
	end,
  opts = function(_, opts)
    opts.style = "night"
    opts.styles = {
      functions = {},
    }
    opts.on_colors = function(colors)
      colors.fg = "#DCD7BA"
    end
  end,
}

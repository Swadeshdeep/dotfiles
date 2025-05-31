return {
  "akinsho/bufferline.nvim",
  opts = {
    highlights = {
      fill = { bg = "#000000" }, -- Black background for the entire bar
      background = { bg = "#000000" }, -- Black for inactive buffers
      buffer_selected = { bg = "#000000" }, -- Black for selected buffer
      separator = { fg = "NONE", bg = "#000000" },
      separator_selected = { fg = "NONE", bg = "#000000" },
      separator_visible = { fg = "NONE", bg = "#000000" },
      indicator_selected = { fg = "NONE", bg = "#000000" },
      tab_close = { fg = "NONE", bg = "#000000" }, -- Black background for close button
      close_button = { fg = "NONE", bg = "#000000" },
      close_button_selected = { fg = "NONE", bg = "#000000" },
      close_button_visible = { fg = "NONE", bg = "#000000" },
    },
    -- options = {
    --   mode = "tabs", -- Disable separators completely
    -- },
  },
}

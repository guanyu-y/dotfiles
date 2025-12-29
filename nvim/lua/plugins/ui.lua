-- ~/.config/nvim/lua/plugins/ui.lua
-- UI plugins: colorscheme, statusline, icons, language support

return {
  -- Colorscheme: tender (active)
  {
    "jacoborus/tender.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tender")
    end,
  },

  -- Colorscheme: molokai (alternative)
  { "tomasr/molokai", lazy = true },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Language support
  { "sheerun/vim-polyglot" },
  { "pangloss/vim-javascript", ft = { "javascript", "javascriptreact" } },

  -- Environment variables
  {
    "ellisonleao/dotenv.nvim",
    config = function()
      require("dotenv").setup({
        enable_on_load = true,
        verbose = false,
      })
    end,
  },
}

-- ~/.config/nvim/lua/plugins/telescope.lua
-- Fuzzy finder configuration

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<C-f>", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<C-g>", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("frecency")
    end,
  },
}

-- ~/.config/nvim/lua/plugins/editor.lua
-- Editor enhancement plugins

return {
  -- Comment toggle
  {
    "tpope/vim-commentary",
    keys = {
      { "<leader>/", "<cmd>Commentary<CR>", mode = { "n", "x" }, desc = "Toggle Comment" },
    },
  },

  -- Dot repeat enhancement
  { "tpope/vim-repeat" },

  -- Surround operations
  { "tpope/vim-surround" },
}

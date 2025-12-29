-- ~/.config/nvim/lua/plugins/git.lua
-- Git integration plugins

return {
  -- Git commands
  { "tpope/vim-fugitive" },

  -- Git diff in gutter
  {
    "airblade/vim-gitgutter",
    event = { "BufReadPre", "BufNewFile" },
  },
}

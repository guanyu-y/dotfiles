-- ~/.config/nvim/lua/plugins/ai.lua
-- AI integration plugins

return {
  -- UI framework (claudecode.nvim dependency)
  {
    "folke/snacks.nvim",
    lazy = false,
  },

  -- Claude Code integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    config = function()
      require("claudecode").setup({
        terminal_cmd = "claude",
        keymaps = {
          toggle = "<leader>cc",
          continue_session = "<leader>c.",
          resume_session = "<leader>cs",
        },
        ui = {
          position = "right",
          width = 0.5,
        },
      })
    end,
  },
}

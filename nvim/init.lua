-- ~/.config/nvim/init.lua
-- Neovim configuration with lazy.nvim

-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core modules
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load plugins with lazy.nvim
require("lazy").setup("plugins", {
  defaults = { lazy = false },
  install = { colorscheme = { "tender" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})

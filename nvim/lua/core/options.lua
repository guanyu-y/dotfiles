-- ~/.config/nvim/lua/core/options.lua
-- Vim options configuration

local opt = vim.opt

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Line numbers
opt.number = true

-- Completion
opt.wildmode = { "list", "longest" }

-- Cursor
opt.whichwrap = "b,s,h,l,<,>,[,]"
opt.virtualedit = "onemore"
opt.scrolloff = 8
opt.cursorline = true
opt.cursorcolumn = true

-- Tabs
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Indent
opt.autoindent = true
opt.smartindent = true
opt.cindent = true

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- File handling
opt.backup = false
opt.swapfile = false
opt.autoread = true
opt.confirm = true
opt.hidden = true

-- Colors
opt.background = "dark"
opt.termguicolors = true

-- Window separator highlight
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5f87af" })

-- ~/.config/nvim/lua/core/keymaps.lua
-- Key mappings configuration

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Visual block mode
keymap("n", "v", "<C-v>", opts)

-- Scroll
keymap("n", "zj", "zt", opts)
keymap("n", "zk", "zb", opts)

-- Redo
keymap("n", "U", "<C-r>", opts)

-- Tab navigation
keymap("n", "tn", ":tabnew<CR>", opts)
keymap("n", "tq", ":tabclose<CR>", opts)
keymap("n", "tl", "gt", opts)
keymap("n", "th", "gT", opts)

-- Fast movement (10 lines/chars)
keymap("", "H", "10h", opts)
keymap("", "J", "10j", opts)
keymap("", "K", "10k", opts)
keymap("", "L", "10l", opts)

-- Pane split and close
keymap("n", "<leader>s", ":split<CR>", opts)
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader><leader>", ":close<CR>", opts)

-- Pane navigation
keymap("n", "gh", "<C-w>h", opts)
keymap("n", "gj", "<C-w>j", opts)
keymap("n", "gk", "<C-w>k", opts)
keymap("n", "gl", "<C-w>l", opts)

-- Clipboard copy
keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+yg_', opts)
keymap("n", "<leader>yy", '"+yy', opts)

-- Clipboard paste
keymap("n", "<leader>p", '"+p', opts)
keymap("v", "<leader>p", '"+p', opts)
keymap("n", "<leader>P", '"+P', opts)
keymap("v", "<leader>P", '"+P', opts)

-- NvimTree toggle
keymap("n", "<C-t>", ":NvimTreeToggle<CR>", opts)

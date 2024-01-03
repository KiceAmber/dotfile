-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local map = Util.safe_keymap_set

map("i", "jk", "<Esc>")

-- basic cursor move keymap
map({ "n", "x" }, "<S-j>", "5j")
map({ "n", "x" }, "<S-j>", "5j")
map("n", "<S-k>", "5k")

-- copy and paste
map("v", "<C-c>", '"+y')
map({ "n", "i" }, "<C-v>", '"+p')

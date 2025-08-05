-- Neovim configuration for Angular development
-- Main init.lua file

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
require("settings")

-- Plugin management
require("plugins")

-- LSP configuration
require("lsp")

-- Keymaps
require("keymaps")

-- Autocommands
require("autocommands")
-- Key mappings for Angular development

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key is set in init.lua

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>o", ":NvimTreeFocus<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
keymap("n", "<leader>fs", ":Telescope grep_string<CR>", opts)
keymap("n", "<leader>fc", ":Telescope commands<CR>", opts)
keymap("n", "<leader>fk", ":Telescope keymaps<CR>", opts)

-- Git
keymap("n", "<leader>gg", ":Gitsigns toggle_current_line_blame<CR>", opts)
keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", opts)
keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", opts)
keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", opts)
keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", opts)

-- LSP
keymap("n", "<leader>lf", ":lua vim.lsp.buf.format({ async = true })<CR>", opts)
keymap("n", "<leader>li", ":LspInfo<CR>", opts)
keymap("n", "<leader>lI", ":LspInstallInfo<CR>", opts)
keymap("n", "<leader>la", ":lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>lj", ":lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
keymap("n", "<leader>lk", ":lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts)
keymap("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<leader>ls", ":lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<leader>lq", ":lua vim.diagnostic.setloclist()<CR>", opts)

-- Diagnostic
keymap("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", opts)
keymap("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", opts)
keymap("n", "<leader>d", ":lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<leader>q", ":lua vim.diagnostic.setloclist()<CR>", opts)

-- Terminal
keymap("n", "<leader>t", ":terminal<CR>", opts)
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Angular specific keymaps
keymap("n", "<leader>ac", ":Telescope find_files search_dirs={'src/app'}<CR>", { desc = "Find Angular components" })
keymap("n", "<leader>as", ":Telescope find_files search_dirs={'src/app'} find_command={'fd','service.ts'}<CR>", { desc = "Find Angular services" })
keymap("n", "<leader>am", ":Telescope find_files search_dirs={'src/app'} find_command={'fd','module.ts'}<CR>", { desc = "Find Angular modules" })

-- Testing
keymap("n", "<leader>tt", ":lua require('neotest').run.run()<CR>", opts)
keymap("n", "<leader>tf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", opts)
keymap("n", "<leader>td", ":lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
keymap("n", "<leader>ts", ":lua require('neotest').run.stop()<CR>", opts)
keymap("n", "<leader>ta", ":lua require('neotest').run.attach()<CR>", opts)

-- Quick save
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<ESC>:w<CR>", opts)

-- Quick quit
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- Split windows
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>s", ":split<CR>", opts)

-- Center cursor when moving
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
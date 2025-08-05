-- Basic Neovim settings for Angular development

local opt = vim.opt

-- General settings
opt.mouse = "a"                       -- Enable mouse support
opt.clipboard = "unnamedplus"         -- Use system clipboard
opt.swapfile = false                  -- Don't create swap files
opt.backup = false                    -- Don't create backup files
opt.writebackup = false               -- Don't create backup before overwriting
opt.undofile = true                   -- Enable persistent undo
opt.updatetime = 250                  -- Faster completion
opt.timeoutlen = 300                  -- Faster key sequence completion

-- UI settings
opt.number = true                     -- Show line numbers
opt.relativenumber = true             -- Show relative line numbers
opt.cursorline = true                 -- Highlight current line
opt.signcolumn = "yes"                -- Always show sign column
opt.wrap = false                      -- Don't wrap lines
opt.scrolloff = 8                     -- Keep 8 lines visible when scrolling
opt.sidescrolloff = 8                 -- Keep 8 columns visible when scrolling
opt.colorcolumn = "80,120"            -- Show column guides
opt.termguicolors = true              -- Enable 24-bit RGB colors

-- Search settings
opt.hlsearch = false                  -- Don't highlight search results
opt.incsearch = true                  -- Show search matches as you type
opt.ignorecase = true                 -- Ignore case in search
opt.smartcase = true                  -- Override ignorecase if search contains uppercase

-- Indentation settings (good for Angular/TypeScript)
opt.tabstop = 2                       -- Number of spaces that a tab counts for
opt.shiftwidth = 2                    -- Number of spaces to use for autoindent
opt.expandtab = true                  -- Use spaces instead of tabs
opt.autoindent = true                 -- Copy indent from current line
opt.smartindent = true                -- Smart autoindenting when starting new line

-- Completion settings
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")             -- Don't show completion messages

-- File type detection
vim.cmd("filetype plugin indent on")

-- Better splits
opt.splitbelow = true                 -- Open horizontal splits below
opt.splitright = true                 -- Open vertical splits to the right

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false                -- Don't fold by default
-- Kickstart.nvim for Angular Development
-- A modern Neovim configuration optimized for Angular development with VSCode-like features
--
--  NOTE: Must have a Nerd Font installed and selected in your terminal
--  https://www.nerdfonts.com/
--
-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable nerd font icons
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set tab and indentation settings for TypeScript/Angular
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Angular file type detection with enhanced support for Angular 17+
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.component.html', '*.container.html' },
  callback = function()
    vim.bo.filetype = 'htmlangular'
    
    -- Set buffer-specific options for better LSP support
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    -- Enable better LSP hover support for complex templates
    vim.keymap.set('n', 'K', function()
      -- Try LSP hover first
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, config)
        if result and result.contents then
          vim.lsp.util.open_floating_preview(result.contents, 'markdown', config)
        else
          -- Fallback to help if LSP hover fails
          local word = vim.fn.expand('<cword>')
          if word and word ~= '' then
            vim.cmd('help ' .. word)
          end
        end
      end)
    end, { buffer = true, desc = 'LSP Hover (Angular Template)' })
    
    -- Set up enhanced syntax highlighting for Angular 17+ control flow
    vim.api.nvim_buf_call(0, function()
      -- Enable Angular-specific syntax highlighting
      vim.cmd('syntax include @typescript syntax/typescript.vim')
      vim.cmd('syntax region angularExpression matchgroup=htmlTag start=/{\\{/ end=/}\\}/ contains=@typescript')
      
      -- Highlight new control flow syntax including @defer
      vim.cmd('syntax match angularControlFlow "@\\(if\\|for\\|switch\\|defer\\|empty\\|placeholder\\|loading\\|error\\|when\\|on\\)" contained')
      vim.cmd('syntax region angularControlBlock start="@\\(if\\|for\\|switch\\|defer\\)" end="}" contains=angularControlFlow,@typescript')
      
      -- Highlight attributes and bindings
      vim.cmd('syntax match angularBinding "\\[\\w\\+\\]" contained')
      vim.cmd('syntax match angularEvent "(\\w\\+)" contained')
      vim.cmd('syntax match angularDirective "\\*\\w\\+" contained')
      vim.cmd('syntax match angularPipe "|\\s*\\w\\+" contained')
      
      -- Set highlighting colors
      vim.cmd('highlight angularControlFlow guifg=#569cd6')
      vim.cmd('highlight angularControlBlock guifg=#4fc1ff')
      vim.cmd('highlight angularBinding guifg=#9cdcfe')
      vim.cmd('highlight angularEvent guifg=#dcdcaa')
      vim.cmd('highlight angularDirective guifg=#c586c0')
      vim.cmd('highlight angularPipe guifg=#4ec9b0')
    end)
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- [[ Plugin: gitsigns ]]
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- [[ Plugin: which-key ]]
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- [[ Plugin: telescope ]]
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- [[ Plugin: LSP Configuration ]]
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          -- Jump to the implementation of the word under your cursor.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          -- Jump to the type of the word under your cursor.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          -- Fuzzy find all the symbols in your current document.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          -- Fuzzy find all the symbols in your current workspace.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          -- Rename the variable under your cursor.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- Execute a code action, usually your cursor needs to be on top of an error
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      local servers = {
        -- TypeScript/JavaScript Server
        ts_ls = {
          root_dir = require('lspconfig.util').root_pattern('tsconfig.json', 'package.json', 'nx.json', 'workspace.json', '.git'),
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              preferences = {
                -- Enable strict null checks
                strictNullChecks = true,
                -- Enable strict function types
                strictFunctionTypes = true,
                -- Enable strict bind call apply
                strictBindCallApply = true,
                -- Enable strict property initialization
                strictPropertyInitialization = true,
                -- Enable no implicit any
                noImplicitAny = true,
                -- Enable no implicit returns
                noImplicitReturns = true,
                -- Enable no implicit this
                noImplicitThis = true,
              },
              -- Suggest improvements for Angular specific patterns
              suggest = {
                autoImports = true,
                completeJSDocs = true,
                completeFunctionCalls = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                autoImports = true,
                completeJSDocs = true,
                completeFunctionCalls = true,
              },
            },
          },
        },

        -- Angular Language Server
        angularls = {
          root_dir = require('lspconfig.util').root_pattern('angular.json', 'project.json', 'nx.json', 'workspace.json'),
          cmd = function()
            -- Try to get Angular Language Server from global npm/nvm
            local function get_global_npm_path()
              -- Try to get npm global path
              local handle = io.popen('npm config get prefix 2>/dev/null')
              if handle then
                local result = handle:read('*a')
                handle:close()
                if result and result ~= '' then
                  return vim.trim(result)
                end
              end
              return nil
            end

            local function get_nvm_current_path()
              -- Try to get current nvm path
              local nvm_current = os.getenv('NVM_BIN')
              if nvm_current then
                return vim.fn.fnamemodify(nvm_current, ':h')
              end
              
              -- Fallback: try to detect from PATH
              local handle = io.popen('which node 2>/dev/null')
              if handle then
                local node_path = handle:read('*a')
                handle:close()
                if node_path and node_path ~= '' then
                  return vim.fn.fnamemodify(vim.trim(node_path), ':h:h')
                end
              end
              return nil
            end

            -- Try different paths for Angular Language Server
            local possible_paths = {}
            
            -- 1. Try nvm current version
            local nvm_path = get_nvm_current_path()
            if nvm_path then
              table.insert(possible_paths, nvm_path .. '/lib/node_modules/@angular/language-server/bin/ngserver')
              table.insert(possible_paths, nvm_path .. '/node_modules/@angular/language-server/bin/ngserver')
            end
            
            -- 2. Try global npm prefix
            local npm_prefix = get_global_npm_path()
            if npm_prefix then
              table.insert(possible_paths, npm_prefix .. '/lib/node_modules/@angular/language-server/bin/ngserver')
              table.insert(possible_paths, npm_prefix .. '/node_modules/@angular/language-server/bin/ngserver')
            end
            
            -- 3. Try common global paths
            local home = os.getenv('HOME')
            if home then
              table.insert(possible_paths, home .. '/.nvm/versions/node/*/lib/node_modules/@angular/language-server/bin/ngserver')
              table.insert(possible_paths, home .. '/.local/lib/node_modules/@angular/language-server/bin/ngserver')
            end
            
            -- 4. Fallback to system paths
            table.insert(possible_paths, '/usr/local/lib/node_modules/@angular/language-server/bin/ngserver')
            table.insert(possible_paths, '/usr/lib/node_modules/@angular/language-server/bin/ngserver')
            
            -- 5. Try using npx as fallback
            table.insert(possible_paths, 'npx')
            
            -- Find the first existing path
            for _, path in ipairs(possible_paths) do
              if path == 'npx' then
                -- Special case for npx
                return { 'npx', '@angular/language-server', '--stdio' }
              elseif vim.fn.executable(path) == 1 then
                return { path, '--stdio' }
              elseif string.find(path, '*') then
                -- Handle glob pattern for nvm versions
                local handle = io.popen('ls -1 ' .. path .. ' 2>/dev/null | head -n 1')
                if handle then
                  local result = handle:read('*a')
                  handle:close()
                  if result and result ~= '' and vim.fn.executable(vim.trim(result)) == 1 then
                    return { vim.trim(result), '--stdio' }
                  end
                end
              end
            end
            
            -- Ultimate fallback
            return { 'ngserver', '--stdio' }
          end,
          on_new_config = function(new_config, new_root_dir)
            -- Add TypeScript and Angular probe locations
            if new_config.cmd and new_config.cmd[1] ~= 'npx' then
              table.insert(new_config.cmd, '--tsProbeLocations')
              table.insert(new_config.cmd, new_root_dir)
              table.insert(new_config.cmd, '--ngProbeLocations')
              table.insert(new_config.cmd, new_root_dir)
              
              -- Ensure TypeScript is available for template analysis
              local ts_server_path = vim.fn.system('npm config get prefix'):gsub('\n', '') .. '/lib/node_modules/typescript/lib'
              if vim.fn.isdirectory(ts_server_path) == 1 then
                table.insert(new_config.cmd, '--tsServerPath')
                table.insert(new_config.cmd, ts_server_path)
              end
              
              -- Enable verbose logging for debugging template issues
              table.insert(new_config.cmd, '--logVerbosity')
              table.insert(new_config.cmd, 'verbose')
              
              -- Enable experimental features for better template support
              table.insert(new_config.cmd, '--enableExperimentalIvy')
              
              -- VSCode-like workspace analysis
              table.insert(new_config.cmd, '--includeCompletionsWithSnippetText')
              table.insert(new_config.cmd, '--includeAutomaticOptionalChainCompletions')
              
              -- Enable workspace component indexing (like VSCode)
              table.insert(new_config.cmd, '--enableWorkspaceSymbols')
              
              -- Better component discovery
              table.insert(new_config.cmd, '--watchOptions')
              table.insert(new_config.cmd, '{"watchFile":"useFsEvents","watchDirectory":"useFsEvents"}')
            end
          end,
          settings = {
            angular = {
              -- Enable strict template checking for better type safety (VSCode default)
              forceStrictTemplates = true,
              -- VSCode-like language service features
              log = "verbose",
              -- Enable all experimental features like VSCode
              experimental = {
                -- Ivy language service features
                ivy = true,
                -- Enable experimental template features
                templateTypeCheck = true,
                -- Better support for complex templates
                enableTemplateTypeChecker = true,
                -- Enable component discovery like VSCode
                enableComponentDiscovery = true,
              },
              -- Angular 17+ Control Flow Support
              enableBlockSyntax = true,
              -- Enable new control flow (@if, @for, @switch, @defer)
              enableControlFlowSyntax = true,
              -- Enable defer block support
              enableDeferBlockSyntax = true,
              -- VSCode-like suggestion behavior
              suggest = {
                includeAutomaticOptionalChainCompletions = true,
                includeCompletionsWithSnippetText = true,
                includeCompletionsForImportStatements = true,
                -- Enable custom component suggestions
                includeCompletionsWithClassMemberSnippets = true,
                autoClosingTags = true,
              },
              -- Enhanced hover and completion support (VSCode behavior)
              hover = {
                -- Enable hover in all template contexts
                enabled = true,
                -- Show type information in hover
                includeTypeInformation = true,
                -- Show documentation in hover
                includeDocumentation = true,
                -- Show component metadata like VSCode
                includeComponentMetadata = true,
              },
              -- Better completion support (VSCode-like)
              completion = {
                -- Enable completion in all contexts
                includeGlobalTypes = true,
                -- Include component inputs/outputs
                includeComponentIO = true,
                -- Include directive inputs/outputs
                includeDirectiveIO = true,
                -- Include pipe suggestions
                includePipes = true,
                -- Custom component support
                includeCustomComponents = true,
                -- Auto import suggestions
                autoImportSuggestions = true,
                -- Path completion for assets
                includePathCompletions = true,
              },
              -- Component analysis settings (VSCode behavior)
              analysis = {
                -- Analyze entire workspace for components
                analyzeEntireWorkspace = true,
                -- Include node_modules analysis
                includeNodeModules = false,
                -- Follow imports for better IntelliSense
                followImports = true,
                -- Index all components
                indexComponents = true,
              },
            },
            -- TypeScript settings for Angular (VSCode-like behavior)
            typescript = {
              preferences = {
                -- Enable block-scoped bindings
                includePackageJsonAutoImports = "on",
                -- Support for Angular 17+ syntax
                allowTextChangesInNewFiles = true,
                -- Better inference for complex expressions
                strictNullChecks = true,
                -- Enable better template analysis
                enableTemplateTypeChecker = true,
                -- VSCode-like import organization
                organizeImports = {
                  includePackageJsonAutoImports = "on",
                },
                -- Better module resolution like VSCode
                moduleResolution = "node",
                -- Enable decorators (Angular uses them extensively)
                experimentalDecorators = true,
                emitDecoratorMetadata = true,
              },
              suggest = {
                -- Enhanced suggestions for new syntax
                enabled = true,
                autoImports = true,
                completeFunctionCalls = true,
                completeJSDocs = true,
                includeCompletionsForModuleExports = true,
                -- VSCode-like suggestion behavior
                includeCompletionsWithClassMemberSnippets = true,
                includeCompletionsWithObjectLiteralMethodSnippets = true,
                includeCompletionsWithInsertText = true,
                names = true,
                paths = true,
                autoImports = true,
              },
              -- Enhanced hover support (VSCode-like)
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
              -- VSCode-like workspace symbol search
              workspaceSymbols = {
                enabled = true,
                includeReferences = true,
              },
              -- Better IntelliSense for large projects
              maxTsServerMemory = 8192,
              -- Enable semantic highlighting
              semanticHighlighting = {
                enabled = true,
              },
            },
          },
        },

        -- HTML Language Server
        html = {
          configurationSection = { 'html', 'css', 'javascript' },
          embeddedLanguages = {
            css = true,
            javascript = true,
          },
          provideFormatter = true,
        },

        -- CSS Language Server
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
        },

        -- JSON Language Server
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- ESLint Language Server
        eslint = {
          settings = {
            workingDirectory = { mode = 'auto' },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'prettier', -- Used to format TypeScript/JavaScript/HTML/CSS
        'eslint_d', -- Used for linting
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- [[ Plugin: Autoformat ]]
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
        html = { 'prettier' },
        htmlangular = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
      },
    },
  },

  -- [[ Plugin: Autocompletion ]]
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- [[ Plugin: Colorscheme ]]
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- [[ Plugin: Highlight todo, notes, etc in comments ]]
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- [[ Plugin: Collection of various small independent plugins/modules ]]
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- [[ Plugin: Treesitter ]]
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'typescript',
        'javascript',
        'json',
        'css',
        'scss',
        'angular',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby', 'htmlangular' },
      },
      indent = { 
        enable = true, 
        disable = { 'ruby' } 
      },
      -- Enhanced Angular 17+ support
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      
      -- Configure Angular-specific treesitter
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      
      -- Ensure Angular parser is properly configured
      if parser_config.angular then
        parser_config.angular.filetype_to_parsername = { 'htmlangular', 'html.angular' }
      end
    end,
  },

  -- Angular-specific TreeSitter plugin
  {
    'nvim-treesitter/nvim-treesitter-angular',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  -- [[ Plugin: File Explorer ]]
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        sort = {
          sorter = 'case_sensitive',
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      }

      vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'Focus file tree' })
    end,
  },

  -- [[ Plugin: Linting ]]
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        typescript = { 'eslint_d' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>l', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },

  -- [[ Plugin: JSON schemas ]]
  {
    'b0o/schemastore.nvim',
    lazy = true,
  },

  -- [[ Plugin: Better TypeScript Errors ]]
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      require('ts-error-translator').setup()
    end,
  },

  -- [[ Plugin: Auto pairs ]]
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- [[ Plugin: Buffer line ]]
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          numbers = 'none',
          close_command = 'bdelete! %d',
          right_mouse_command = 'bdelete! %d',
          left_mouse_command = 'buffer %d',
          middle_mouse_command = nil,
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return '(' .. count .. ')'
          end,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              text_align = 'left',
              separator = true,
            },
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = 'slant',
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },
        },
      }

      vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
      vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    end,
  },

  -- [[ Plugin: Angular-specific emmet support ]]
  {
    'mattn/emmet-vim',
    ft = { 'html', 'htmlangular', 'css', 'scss', 'typescript', 'javascript' },
    config = function()
      vim.g.user_emmet_leader_key = '<C-Z>'
      vim.g.user_emmet_settings = {
        html = {
          snippets = {
            ['ng-if'] = '<div *ngIf="${1}">|</div>',
            ['ng-for'] = '<div *ngFor="let ${1:item} of ${2:items}">|</div>',
            ['ng-class'] = '<div [ngClass]="${1}">|</div>',
            ['ng-style'] = '<div [ngStyle]="${1}">|</div>',
          },
        },
      }
    end,
  },

  -- [[ Plugin: Git integration ]]
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse', 'GRemove', 'GRename', 'Glgrep', 'Gedit' },
    ft = { 'fugitive' },
  },

  -- [[ Plugin: GitHub integration ]]
  {
    'tpope/vim-rhubarb',
    dependencies = { 'tpope/vim-fugitive' },
    cmd = { 'GBrowse' },
  },

  -- [[ Plugin: Comments ]]
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  -- [[ Plugin: Indent guides ]]
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- [[ Plugin: Color highlighter ]]
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- [[ Angular Development Specific Configuration ]]

-- Set up angular.json schema for autocompletion
vim.api.nvim_create_autocmd('BufRead', {
  pattern = 'angular.json',
  callback = function()
    vim.bo.filetype = 'json'
  end,
})

-- Better error handling for Angular templates (VSCode-like behavior)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'htmlangular',
  callback = function()
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = false,
      float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
      },
    })
    
    -- VSCode-like workspace awareness for custom components
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Set up auto-completion for custom components
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Enhanced auto-completion trigger characters (like VSCode)
    local completion_triggers = { '<', '>', '"', "'", '=', ' ', '(', ')', '[', ']', '{', '}', '*', '@' }
    
    -- Set up completion triggering
    for _, char in ipairs(completion_triggers) do
      vim.keymap.set('i', char, char .. '<C-x><C-o>', { buffer = bufnr, silent = true })
    end
    
    -- Force LSP to analyze the workspace for component discovery
    vim.defer_fn(function()
      local clients = {}
      if vim.lsp.get_clients then
        clients = vim.lsp.get_clients({ bufnr = bufnr })
      end
      
      for _, client in ipairs(clients) do
        if client.name == 'angularls' then
          -- Request workspace symbols to ensure components are indexed
          client.request('workspace/symbol', { query = 'mapal' }, function() end)
          break
        end
      end
    end, 1000)
  end,
})

-- Function to detect if current project is using Nx
local function is_nx_workspace()
  return vim.fn.filereadable('nx.json') == 1 or vim.fn.filereadable('workspace.json') == 1
end

-- Function to get CLI command (nx or ng)
local function get_cli_cmd()
  return is_nx_workspace() and 'nx' or 'ng'
end

-- Custom keymaps for Angular/Nx development
vim.keymap.set('n', '<leader>ac', function()
  local cmd = get_cli_cmd()
  local name = vim.fn.input('Component name: ')
  if name and name ~= '' then
    vim.cmd('!' .. cmd .. ' generate component ' .. name)
  end
end, { desc = '[A]ngular [C]omponent' })

vim.keymap.set('n', '<leader>as', function()
  local cmd = get_cli_cmd()
  local name = vim.fn.input('Service name: ')
  if name and name ~= '' then
    vim.cmd('!' .. cmd .. ' generate service ' .. name)
  end
end, { desc = '[A]ngular [S]ervice' })

vim.keymap.set('n', '<leader>am', function()
  local cmd = get_cli_cmd()
  local name = vim.fn.input('Module name: ')
  if name and name ~= '' then
    vim.cmd('!' .. cmd .. ' generate module ' .. name)
  end
end, { desc = '[A]ngular [M]odule' })

vim.keymap.set('n', '<leader>ag', function()
  local cmd = get_cli_cmd()
  local name = vim.fn.input('Guard name: ')
  if name and name ~= '' then
    vim.cmd('!' .. cmd .. ' generate guard ' .. name)
  end
end, { desc = '[A]ngular [G]uard' })

vim.keymap.set('n', '<leader>ap', function()
  local cmd = get_cli_cmd()
  local name = vim.fn.input('Pipe name: ')
  if name and name ~= '' then
    vim.cmd('!' .. cmd .. ' generate pipe ' .. name)
  end
end, { desc = '[A]ngular [P]ipe' })

vim.keymap.set('n', '<leader>ad', function()
  local cmd = get_cli_cmd()
  local name = vim.fn.input('Directive name: ')
  if name and name ~= '' then
    vim.cmd('!' .. cmd .. ' generate directive ' .. name)
  end
end, { desc = '[A]ngular [D]irective' })

-- Angular/Nx build and serve commands
vim.keymap.set('n', '<leader>ab', function()
  local cmd = get_cli_cmd()
  if is_nx_workspace() then
    -- For Nx, prompt for project name
    local project = vim.fn.input('Project to build (leave empty for default): ')
    if project and project ~= '' then
      vim.cmd('!' .. cmd .. ' build ' .. project)
    else
      vim.cmd('!' .. cmd .. ' build')
    end
  else
    vim.cmd('!' .. cmd .. ' build')
  end
end, { desc = '[A]ngular [B]uild' })

vim.keymap.set('n', '<leader>ar', function()
  local cmd = get_cli_cmd()
  if is_nx_workspace() then
    -- For Nx, prompt for project name
    local project = vim.fn.input('Project to serve (leave empty for default): ')
    if project and project ~= '' then
      vim.cmd('!' .. cmd .. ' serve ' .. project)
    else
      vim.cmd('!' .. cmd .. ' serve')
    end
  else
    vim.cmd('!' .. cmd .. ' serve')
  end
end, { desc = '[A]ngular Se[r]ve' })

vim.keymap.set('n', '<leader>at', function()
  local cmd = get_cli_cmd()
  if is_nx_workspace() then
    -- For Nx, prompt for project name
    local project = vim.fn.input('Project to test (leave empty for default): ')
    if project and project ~= '' then
      vim.cmd('!' .. cmd .. ' test ' .. project)
    else
      vim.cmd('!' .. cmd .. ' test')
    end
  else
    vim.cmd('!' .. cmd .. ' test')
  end
end, { desc = '[A]ngular [T]est' })

-- Nx-specific commands
if is_nx_workspace() then
  vim.keymap.set('n', '<leader>ng', '<cmd>!nx graph<CR>', { desc = '[N]x [G]raph' })
  vim.keymap.set('n', '<leader>nl', '<cmd>!nx list<CR>', { desc = '[N]x [L]ist plugins' })
  vim.keymap.set('n', '<leader>nr', '<cmd>!nx reset<CR>', { desc = '[N]x [R]eset cache' })
  
  vim.keymap.set('n', '<leader>nf', function()
    local scope = vim.fn.input('Nx format scope (leave empty for all): ')
    if scope and scope ~= '' then
      vim.cmd('!nx format --projects=' .. scope)
    else
      vim.cmd('!nx format')
    end
  end, { desc = '[N]x [F]ormat' })
  
  vim.keymap.set('n', '<leader>na', function()
    local target = vim.fn.input('Target to run for affected projects: ', 'build')
    if target and target ~= '' then
      vim.cmd('!nx affected --target=' .. target)
    end
  end, { desc = '[N]x [A]ffected' })
end

-- Command to refresh Angular Language Server for template issues
vim.api.nvim_create_user_command('AngularRefresh', function()
  -- Restart Angular Language Server
  vim.cmd('LspRestart angularls')
  
  -- Wait a moment for restart
  vim.defer_fn(function()
    -- Force reanalysis of current buffer if it's an Angular template
    if vim.bo.filetype == 'htmlangular' then
      -- Trigger document sync
      vim.lsp.buf.format({ async = false })
      
      print('✓ Angular Language Server refreshed for template: ' .. vim.fn.expand('%:t'))
      print('Try Shift+K again for hover information')
    else
      print('AngularRefresh should be used in Angular template files (.component.html)')
    end
  end, 1000)
end, { desc = 'Refresh Angular Language Server for template issues' })

-- Command to force workspace component analysis (like VSCode's reload window)
vim.api.nvim_create_user_command('AngularReloadWorkspace', function()
  print('🔄 Reloading Angular workspace for component discovery...')
  
  -- Restart both TypeScript and Angular Language Servers
  vim.cmd('LspRestart ts_ls')
  vim.cmd('LspRestart angularls')
  
  -- Wait for restart and force workspace analysis
  vim.defer_fn(function()
    -- Trigger workspace symbol refresh
    local clients = {}
    if vim.lsp.get_clients then
      clients = vim.lsp.get_clients({ name = 'angularls' })
    end
    
    for _, client in ipairs(clients) do
      if client.name == 'angularls' then
        -- Request workspace symbols to trigger component indexing
        client.request('workspace/symbol', { query = '' }, function(err, result)
          if not err then
            print('✓ Angular workspace reloaded - custom components should now be available')
            print('✓ Found ' .. (result and #result or 0) .. ' workspace symbols')
          end
        end)
        break
      end
    end
    
    print('✓ Workspace analysis complete - try hovering over custom components')
  end, 2000)
end, { desc = 'Reload Angular workspace for component discovery (like VSCode reload)' })

-- Diagnostic command for Angular Language Server setup
vim.api.nvim_create_user_command('AngularDiagnostic', function()
  local function check_path(path, name)
    if vim.fn.executable(path) == 1 then
      print('✓ ' .. name .. ': ' .. path)
      return true
    else
      print('✗ ' .. name .. ': ' .. path .. ' (not found)')
      return false
    end
  end

  local function check_env()
    print('--- Environment Information ---')
    print('Node.js: ' .. (vim.fn.system('node --version'):gsub('\n', '') or 'not found'))
    print('npm: ' .. (vim.fn.system('npm --version'):gsub('\n', '') or 'not found'))
    print('npm prefix: ' .. (vim.fn.system('npm config get prefix'):gsub('\n', '') or 'not found'))
    
    local nvm_bin = os.getenv('NVM_BIN')
    if nvm_bin then
      print('NVM_BIN: ' .. nvm_bin)
    else
      print('NVM_BIN: not set')
    end
    
    -- Check workspace type
    if is_nx_workspace() then
      print('Workspace: Nx monorepo detected')
      print('CLI command: nx')
    else
      print('Workspace: Standard Angular project')
      print('CLI command: ng')
    end
    
    -- Check Angular version for control flow support
    local ng_version = vim.fn.system('ng version 2>/dev/null | grep "Angular CLI" || echo "not found"'):gsub('\n', '')
    if ng_version and ng_version ~= 'not found' then
      print('Angular CLI: ' .. ng_version)
      
      -- Check if project supports new control flow
      local package_json = vim.fn.readfile('package.json')
      if package_json then
        local content = table.concat(package_json, '\n')
        local angular_version = content:match('"@angular/core": "([^"]+)"')
        if angular_version then
          print('Angular Core: ' .. angular_version)
          
          -- Check if version supports new control flow (17+)
          local major_version = tonumber(angular_version:match('(%d+)'))
          if major_version and major_version >= 17 then
            print('✓ Angular 17+ control flow (@if, @for, @switch) supported')
          else
            print('⚠ Angular ' .. major_version .. ' - consider upgrading to 17+ for new control flow syntax')
          end
        end
      end
    else
      print('Angular CLI: not found')
    end
    print('')
  end

  local function check_angular_ls()
    print('--- Angular Language Server Detection ---')
    
    -- Get the actual command that would be used (compatible with different Neovim versions)
    local servers = {}
    
    -- Try newer Neovim API first
    if vim.lsp.get_clients then
      servers = vim.lsp.get_clients({ name = 'angularls' })
    elseif vim.lsp.get_active_clients then
      -- Fallback for older Neovim versions
      local all_clients = vim.lsp.get_active_clients()
      for _, client in ipairs(all_clients) do
        if client.name == 'angularls' then
          table.insert(servers, client)
        end
      end
    end
    
    if #servers > 0 then
      print('✓ Angular LS is running with command: ' .. vim.inspect(servers[1].config.cmd))
      print('✓ Angular LS attached to buffers: ' .. #servers)
    else
      print('○ Angular LS not currently running')
      
      -- Try to get the command that would be used
      local angularls_config = require('lspconfig').angularls
      if angularls_config and angularls_config.cmd then
        local cmd = angularls_config.cmd()
        print('Angular LS would use command: ' .. vim.inspect(cmd))
        if cmd and cmd[1] then
          check_path(cmd[1], 'Angular Language Server')
        end
      end
    end
    print('')
  end

  local function check_npm_packages()
    print('--- Global npm Packages ---')
    local handle = io.popen('npm list -g @angular/language-server @angular/cli typescript 2>/dev/null')
    if handle then
      local result = handle:read('*a')
      handle:close()
      print(result)
    else
      print('Could not check npm packages')
    end
    
    -- Check TypeScript availability specifically
    print('--- TypeScript for Template IntelliSense ---')
    local ts_version = vim.fn.system('tsc --version 2>/dev/null'):gsub('\n', '')
    if ts_version and ts_version ~= '' then
      print('✓ TypeScript compiler: ' .. ts_version)
    else
      print('✗ TypeScript compiler not found - required for Angular template IntelliSense')
    end
    
    local ts_server_path = vim.fn.system('npm config get prefix'):gsub('\n', '') .. '/lib/node_modules/typescript/lib'
    if vim.fn.isdirectory(ts_server_path) == 1 then
      print('✓ TypeScript lib directory: ' .. ts_server_path)
    else
      print('✗ TypeScript lib directory not found: ' .. ts_server_path)
    end
    print('')
  end

  check_env()
  check_angular_ls()
  check_npm_packages()
  
  print('--- LSP Status ---')
  vim.cmd('LspInfo')
  
  -- Check current buffer LSP attachment
  if vim.bo.filetype == 'htmlangular' then
    print('')
    print('--- Current Template Buffer ---')
    local clients = {}
    if vim.lsp.get_clients then
      clients = vim.lsp.get_clients({ bufnr = 0 })
    elseif vim.lsp.buf_get_clients then
      clients = vim.lsp.buf_get_clients(0)
    end
    
    if #clients > 0 then
      for _, client in ipairs(clients) do
        if client.name == 'angularls' then
          print('✓ Angular LS attached to current buffer')
          print('✓ Hover capability: ' .. (client.server_capabilities.hoverProvider and 'enabled' or 'disabled'))
          break
        end
      end
    else
      print('✗ No LSP clients attached to current template buffer')
      print('Try :AngularRefresh to fix template LSP issues')
    end
  end
end, { desc = 'Diagnose Angular Language Server setup' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
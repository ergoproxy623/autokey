-- Autocommands for Angular development

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General Settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Don't auto comment new lines
autocmd("BufEnter", {
  group = general,
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end,
})

-- Angular specific
local angular = augroup("Angular", { clear = true })

-- Set filetype for Angular template files
autocmd({ "BufRead", "BufNewFile" }, {
  group = angular,
  pattern = "*.component.html",
  command = "set filetype=html",
})

-- Set filetype for Angular TypeScript files
autocmd({ "BufRead", "BufNewFile" }, {
  group = angular,
  pattern = { "*.component.ts", "*.service.ts", "*.module.ts", "*.guard.ts", "*.pipe.ts", "*.directive.ts" },
  command = "set filetype=typescript",
})

-- Set specific settings for Angular files
autocmd("FileType", {
  group = angular,
  pattern = { "typescript", "html", "css", "scss" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- JSON files
local json_group = augroup("JSON", { clear = true })

autocmd("FileType", {
  group = json_group,
  pattern = "json",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Auto format on save for specific filetypes
local format_on_save = augroup("FormatOnSave", { clear = true })

autocmd("BufWritePre", {
  group = format_on_save,
  pattern = { "*.ts", "*.js", "*.html", "*.css", "*.scss", "*.json" },
  callback = function()
    if vim.lsp.buf.server_ready() then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- Terminal settings
local terminal = augroup("Terminal", { clear = true })

autocmd("TermOpen", {
  group = terminal,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.cmd("startinsert")
  end,
})

-- Close terminal with q
autocmd("FileType", {
  group = terminal,
  pattern = "terminal",
  callback = function()
    vim.keymap.set("n", "q", ":q<CR>", { buffer = true, silent = true })
  end,
})

-- File tree settings
local tree = augroup("NvimTree", { clear = true })

autocmd("VimEnter", {
  group = tree,
  pattern = "*",
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[1]) == 1 then
      vim.cmd("cd " .. vim.fn.argv()[1])
      vim.cmd("NvimTreeOpen")
    end
  end,
})

-- LSP settings
local lsp_group = augroup("LSP", { clear = true })

-- Show line diagnostics automatically in hover window
autocmd("CursorHold", {
  group = lsp_group,
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Update diagnostics in insert mode
autocmd({ "CursorHold", "CursorHoldI" }, {
  group = lsp_group,
  pattern = "*",
  callback = function()
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        source = "always",
      },
      float = {
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
})
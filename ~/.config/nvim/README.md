# Neovim Angular LSP Configuration

This configuration provides a complete development environment for Angular projects with Language Server Protocol (LSP) support.

## Features

- **Angular Language Server**: Full Angular support with template and TypeScript integration
- **TypeScript Language Server**: Advanced TypeScript support with inlay hints
- **HTML/CSS/SCSS Language Servers**: Complete web development support
- **ESLint Integration**: Automatic linting and fixing on save
- **JSON Schema Support**: Intelligent JSON completion with schema validation
- **File Explorer**: nvim-tree for project navigation
- **Fuzzy Finding**: Telescope for fast file and text searching
- **Git Integration**: Gitsigns for git status and operations
- **Testing**: Neotest integration for running Jest tests
- **Autocompletion**: nvim-cmp with LSP-based completion
- **Syntax Highlighting**: TreeSitter for advanced syntax highlighting

## Key Bindings

### Leader Key
The leader key is set to `<Space>`.

### LSP Operations
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Go to references
- `K` - Show hover information
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document
- `[d` / `]d` - Navigate diagnostics

### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>e` - Toggle file explorer
- `<leader>o` - Focus file explorer

### Angular Specific
- `<leader>ac` - Find Angular components
- `<leader>as` - Find Angular services
- `<leader>am` - Find Angular modules

### Testing
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run tests in current file
- `<leader>ts` - Stop tests

### Git
- `<leader>gg` - Toggle git blame
- `<leader>gp` - Preview git hunk
- `<leader>gs` - Stage git hunk
- `<leader>gr` - Reset git hunk

### Navigation
- `<C-h/j/k/l>` - Navigate between windows
- `<S-h/l>` - Navigate between buffers
- `<leader>v` - Vertical split
- `<leader>s` - Horizontal split

## Installation

### Prerequisites

1. **Neovim** (v0.8+)
2. **Node.js** (for language servers)
3. **Git** (for plugin management)

### Language Servers

The following language servers are automatically installed via Mason:
- `@angular/language-server` - Angular Language Server
- `typescript-language-server` - TypeScript Language Server
- `vscode-langservers-extracted` - HTML, CSS, JSON, ESLint servers

### First Run

1. Start Neovim: `nvim`
2. The plugin manager (lazy.nvim) will automatically install all plugins
3. LSP servers will be installed automatically via Mason
4. Restart Neovim after initial setup

## File Structure

```
~/.config/nvim/
├── init.lua              # Main configuration entry point
├── lua/
│   ├── settings.lua      # Basic Neovim settings
│   ├── plugins.lua       # Plugin management with lazy.nvim
│   ├── lsp.lua          # LSP configuration
│   ├── keymaps.lua      # Key mappings
│   └── autocommands.lua # Autocommands
└── README.md            # This file
```

## Angular Project Setup

For optimal Angular development experience:

1. Ensure your project has `angular.json` or `project.json` in the root
2. Install project dependencies: `npm install`
3. Open Neovim in the project root: `nvim .`
4. The Angular Language Server will automatically detect your project

## Customization

### Adding Custom Keymaps
Edit `~/.config/nvim/lua/keymaps.lua` to add your custom key mappings.

### Plugin Configuration
Edit `~/.config/nvim/lua/plugins.lua` to add or configure plugins.

### LSP Settings
Edit `~/.config/nvim/lua/lsp.lua` to modify language server configurations.

## Troubleshooting

### LSP Not Working
1. Run `:LspInfo` to check server status
2. Run `:Mason` to verify language servers are installed
3. Check if your project has proper configuration files (angular.json, tsconfig.json)

### Plugin Issues
1. Run `:Lazy` to check plugin status
2. Use `:Lazy sync` to update plugins
3. Check `:checkhealth` for system issues

### Angular Language Server Issues
1. Ensure you're in an Angular project directory
2. Check that `angular.json` exists in project root
3. Verify TypeScript version compatibility

## Dependencies

### Required System Tools
- `git` - For plugin management
- `node` - For language servers
- `npm` - For installing language servers
- `fd` (optional) - For faster file searching
- `ripgrep` (optional) - For faster text searching

### Language Servers Installed
- Angular Language Server (`@angular/language-server`)
- TypeScript Language Server (`typescript-language-server`)
- HTML Language Server
- CSS Language Server
- JSON Language Server
- ESLint Language Server

## Features in Detail

### Angular Support
- Component template autocomplete
- Directive and pipe completion
- Angular-specific diagnostics
- Template syntax highlighting
- Component and template navigation

### TypeScript Features
- Advanced type checking
- Inlay hints for types and parameters
- Import organization
- Refactoring support
- Symbol navigation

### Code Quality
- ESLint integration with auto-fix on save
- Prettier formatting (if configured in project)
- Real-time error detection
- Import sorting and cleanup

This configuration provides a comprehensive Angular development environment with modern LSP features and efficient key bindings.
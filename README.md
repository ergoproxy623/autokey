# Kickstart.nvim for Angular Development

A modern, comprehensive Neovim configuration optimized for Angular development with VSCode-like features and the Angular Language Server.

## 🚀 Features

### Angular-Specific Features
- **Angular Language Server (ALS)** with full IntelliSense support
- **Angular CLI integration** with built-in commands
- **Angular file type detection** for `.component.html` files
- **Emmet support** with Angular-specific snippets
- **Angular TreeSitter** syntax highlighting
- **TypeScript/JavaScript** language server with inlay hints

### Development Tools
- **LSP Configuration**: Angular, TypeScript, HTML, CSS, JSON, ESLint
- **Auto-formatting**: Prettier integration with format-on-save
- **Linting**: ESLint with real-time error detection
- **Auto-completion**: Intelligent code completion with snippets
- **File Explorer**: nvim-tree with Angular project structure support
- **Fuzzy Finding**: Telescope for files, symbols, and text search
- **Git Integration**: Gitsigns, Fugitive, and GitHub support

### UI/UX Enhancements
- **Modern Theme**: Tokyo Night color scheme
- **Buffer Line**: Visual buffer tabs with diagnostics
- **Status Line**: Mini.nvim statusline with file info
- **Which Key**: Interactive keybinding help
- **Indent Guides**: Visual indentation guides
- **Color Highlighting**: CSS/SCSS color preview

## 📋 Prerequisites

### Required Software
```bash
# Neovim 0.10.0 or later
# Check version with: nvim --version

# Node.js and npm (for Angular CLI and language servers)
node --version  # Should be 18.x or later
npm --version

# Git
git --version

# Build tools (for compiling plugins)
# Ubuntu/Debian:
sudo apt install build-essential

# macOS:
xcode-select --install

# Additional tools
sudo apt install ripgrep fd-find unzip curl  # Ubuntu/Debian
brew install ripgrep fd unzip curl           # macOS
```

### Optional but Recommended
- **Nerd Font**: For icons and symbols ([download here](https://www.nerdfonts.com/))
- **Angular CLI**: `npm install -g @angular/cli`

## 🛠️ Installation

### 1. Backup Existing Configuration
```bash
# Backup your current Neovim config
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

### 2. Clone This Configuration
```bash
# Clone to Neovim config directory
git clone https://github.com/yourusername/kickstart-angular-nvim ~/.config/nvim

# Or copy the init.lua file directly
mkdir -p ~/.config/nvim
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/yourusername/kickstart-angular-nvim/main/init.lua
```

### 3. Install Language Servers and Tools
```bash
# Install Angular Language Server and related tools
npm install -g @angular/language-server
npm install -g typescript
npm install -g @angular/cli

# Install additional formatters and linters
npm install -g prettier
npm install -g eslint_d
```

### 4. First Launch
```bash
# Start Neovim - plugins will install automatically
nvim

# Wait for all plugins to install (this may take a few minutes)
# You can check progress with :Lazy
```

## 🎯 Key Bindings

### Leader Key
The leader key is set to `<Space>`.

### Essential Keybindings

#### File Operations
| Key | Description |
|-----|-------------|
| `<leader>sf` | Search files |
| `<leader>sg` | Search by grep |
| `<leader>sw` | Search current word |
| `<leader><leader>` | Find buffers |
| `<C-n>` | Toggle file tree |
| `<leader>e` | Focus file tree |

#### LSP & Code Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format buffer |
| `<leader>l` | Trigger linting |

#### Angular-Specific Commands
| Key | Description |
|-----|-------------|
| `<leader>ac` | Generate Angular component |
| `<leader>as` | Generate Angular service |
| `<leader>am` | Generate Angular module |
| `<leader>ag` | Generate Angular guard |
| `<leader>ap` | Generate Angular pipe |
| `<leader>ad` | Generate Angular directive |
| `<leader>ab` | Angular build |
| `<leader>ar` | Angular serve |
| `<leader>at` | Angular test |

#### Buffer and Window Management
| Key | Description |
|-----|-------------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<C-h/j/k/l>` | Navigate splits |

#### Git Integration
| Key | Description |
|-----|-------------|
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |

## 🏗️ Project Structure

This configuration works best with Angular projects that have the following structure:
```
my-angular-app/
├── angular.json          # Detected as root marker
├── package.json
├── tsconfig.json
├── src/
│   ├── app/
│   │   ├── components/
│   │   ├── services/
│   │   ├── modules/
│   │   └── ...
│   ├── assets/
│   └── ...
└── ...
```

## ⚙️ Configuration

### Angular Language Server Settings

The configuration includes optimized settings for the Angular Language Server:

```lua
angularls = {
  root_dir = require('lspconfig.util').root_pattern('angular.json', 'project.json'),
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = new_config.cmd or {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      new_root_dir,
      '--ngProbeLocations',
      new_root_dir,
    }
  end,
},
```

### TypeScript Settings

Enhanced TypeScript configuration with inlay hints:

```lua
ts_ls = {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        -- ... more settings
      },
    },
  },
},
```

### Formatting and Linting

- **Prettier**: Auto-formatting for TypeScript, JavaScript, HTML, CSS, JSON
- **ESLint**: Real-time linting with `eslint_d`
- **Format on save**: Enabled by default

## 🔧 Customization

### Adding New Plugins

Edit `~/.config/nvim/init.lua` and add to the `require('lazy').setup({` section:

```lua
-- Example: Adding a new plugin
{
  'plugin-author/plugin-name',
  config = function()
    -- Plugin configuration
  end,
},
```

### Modifying Keybindings

Add custom keybindings in the configuration:

```lua
-- Example: Custom Angular keybinding
vim.keymap.set('n', '<leader>ai', '<cmd>!ng generate interface ', { desc = '[A]ngular [I]nterface' })
```

### Changing Theme

Replace the colorscheme section:

```lua
{
  'catppuccin/nvim',  -- Example: different theme
  name = 'catppuccin',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'catppuccin'
  end,
},
```

## 🚨 Troubleshooting

### Common Issues

#### Angular Language Server Not Starting
```bash
# Check if Angular Language Server is installed
npm list -g @angular/language-server

# Reinstall if needed
npm install -g @angular/language-server typescript
```

#### LSP Not Working
```bash
# Check LSP status
:LspInfo

# Check health
:checkhealth
```

#### Formatting Not Working
```bash
# Check if prettier is installed
npm list -g prettier

# Install if needed
npm install -g prettier

# Check conform status
:ConformInfo
```

### Debug Mode

Enable verbose logging:

```lua
-- Add to init.lua for debugging
vim.lsp.set_log_level("debug")
-- Then check logs with :LspLog
```

## 📚 Learning Resources

### Neovim
- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [LSP Documentation](https://neovim.io/doc/user/lsp.html)

### Angular
- [Angular Documentation](https://angular.io/docs)
- [Angular CLI Reference](https://angular.io/cli)
- [Angular Language Service](https://angular.io/guide/language-service)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with an Angular project
5. Submit a pull request

## 📄 License

This configuration is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and is licensed under the MIT License.

## 🙏 Acknowledgments

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Base configuration
- [Angular Language Service](https://github.com/angular/vscode-ng-language-service) - Language server
- [LazyVim](https://github.com/LazyVim/LazyVim) - Plugin management inspiration
- All the amazing plugin authors who make Neovim awesome!

---

**Happy coding with Angular and Neovim! 🚀**

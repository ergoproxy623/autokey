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

#### If using nvm (Node Version Manager)
```bash
# Source nvm if not already in your shell profile
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Use the latest LTS Node.js version
nvm install --lts
nvm use --lts

# Install global packages
npm install -g @angular/language-server
npm install -g typescript
npm install -g @angular/cli
npm install -g prettier
npm install -g eslint_d
```

#### If using system npm
```bash
# Install Angular Language Server and related tools
npm install -g @angular/language-server
npm install -g typescript
npm install -g @angular/cli

# Install additional formatters and linters
npm install -g prettier
npm install -g eslint_d
```

> **Note**: The configuration automatically detects your nvm setup and uses the Angular Language Server from your current nvm environment.

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

#### Angular/Nx Commands
| Key | Description |
|-----|-------------|
| `<leader>ac` | Generate component (ng/nx generate component) |
| `<leader>as` | Generate service (ng/nx generate service) |
| `<leader>am` | Generate module (ng/nx generate module) |
| `<leader>ag` | Generate guard (ng/nx generate guard) |
| `<leader>ap` | Generate pipe (ng/nx generate pipe) |
| `<leader>ad` | Generate directive (ng/nx generate directive) |
| `<leader>ab` | Build project (ng/nx build) |
| `<leader>ar` | Serve project (ng/nx serve) |
| `<leader>at` | Test project (ng/nx test) |

#### Nx-Specific Commands (only in Nx workspaces)
| Key | Description |
|-----|-------------|
| `<leader>ng` | Show Nx dependency graph |
| `<leader>nl` | List Nx plugins |
| `<leader>nr` | Reset Nx cache |
| `<leader>nf` | Format code (nx format) |
| `<leader>na` | Run target on affected projects |

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

This configuration works with both standard Angular projects and Nx monorepos:

### Standard Angular Project
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

### Nx Monorepo
```
my-nx-workspace/
├── nx.json               # Detected as root marker
├── workspace.json        # Legacy Nx workspaces
├── package.json
├── tsconfig.base.json
├── apps/
│   ├── my-app/
│   ├── my-api/
│   └── ...
├── libs/
│   ├── shared/
│   ├── ui/
│   └── ...
├── tools/
└── ...
```

> **Note**: The configuration automatically detects whether you're in an Nx workspace and adjusts commands accordingly (`nx` vs `ng`).

## ⚙️ Configuration

### Angular Language Server Settings

The configuration includes optimized settings for the Angular Language Server with enhanced type checking:

```lua
angularls = {
  root_dir = require('lspconfig.util').root_pattern('angular.json', 'project.json', 'nx.json', 'workspace.json'),
  settings = {
    angular = {
      -- Enable strict template checking for better type safety
      forceStrictTemplates = true,
      -- Enable experimental features
      experimental = {
        -- Ivy language service features
        ivy = true,
      },
    },
  },
  -- ... automatic path detection logic
},
```

#### Key Features:
- **Strict Template Checking**: Enabled `forceStrictTemplates` for better type safety in templates
- **TypeScript Integration**: Automatically configures TypeScript server path for template IntelliSense
- **Nx Support**: Automatic detection of Nx workspaces (`nx.json`, `workspace.json`)
- **Enhanced Type Checking**: Stricter TypeScript preferences for better code quality
- **Intelligent Path Detection**: Automatically finds Angular Language Server from nvm/npm global modules

#### Why TypeScript is Required for Angular Templates:

Angular template IntelliSense **requires TypeScript** for the following critical features:

```html
<!-- Type checking for property bindings -->
<div [hidden]="isVisible">{{ userName }}</div>
<!--           ↑                ↑        -->
<!--      boolean type      string type  -->

<!-- Method signature validation -->
<button (click)="saveUser($event)">Save</button>
<!--              ↑                      -->
<!--        Validates method exists      -->
<!--        and parameter types          -->

<!-- Structural directive type inference -->
<li *ngFor="let user of users; index as i">
<!--        ↑           ↑            ↑    -->
<!--    inferred    array type   number   -->
  {{ user.name }} - {{ i }}
</li>

<!-- Form control type safety -->
<input [formControl]="userForm.get('email')" />
<!--                    ↑                    -->
<!--         TypeScript validates          -->
<!--         form control exists           -->
```

**Without TypeScript:**
- ❌ No property binding validation
- ❌ No method signature checking  
- ❌ No type inference in templates
- ❌ No auto-completion for component properties
- ❌ `forceStrictTemplates` won't work

### How Angular + TypeScript Language Servers Work Together

This configuration uses **two complementary language servers**:

1. **TypeScript Language Server (`ts_ls`)**: 
   - Handles `.ts` files (components, services, etc.)
   - Provides TypeScript IntelliSense, type checking, refactoring
   - Manages imports, exports, and module resolution

2. **Angular Language Server (`angularls`)**:
   - Handles `.html` Angular templates 
   - **Uses TypeScript** to understand component context
   - Provides template-specific features (directives, pipes, etc.)
   - Enables `forceStrictTemplates` type checking

**The magic happens when they coordinate:**
```
Component.ts ←→ TypeScript LS ←→ Angular LS ←→ Component.html
    ↓                              ↓              ↓
Type info ──────────────→ Template analysis ──→ IntelliSense
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

#### TypeScript Not Working for Templates

If you're not getting IntelliSense in Angular templates, TypeScript might not be properly configured:

**Check TypeScript installation:**
```bash
# Verify TypeScript is installed globally
tsc --version

# If not installed:
npm install -g typescript

# Verify with diagnostic command
:AngularDiagnostic
```

**Common TypeScript issues:**
```bash
# 1. TypeScript not in global npm
npm list -g typescript

# 2. Wrong TypeScript version (Angular requires 4.0+)
npm install -g typescript@latest

# 3. Project-specific tsconfig issues
# Make sure your project has a valid tsconfig.json

# 4. Angular Language Server can't find TypeScript
# The config automatically sets --tsServerPath, but you can verify:
npm config get prefix
ls -la $(npm config get prefix)/lib/node_modules/typescript/lib
```

**Template IntelliSense not working:**
- ✅ Ensure `*.component.html` files are detected as `htmlangular` filetype
- ✅ Check `:LspInfo` shows Angular Language Server is attached
- ✅ Verify TypeScript compiler is available globally
- ✅ Confirm `tsconfig.json` exists in project root

#### Angular 17+ Control Flow (@if, @for, @switch) Not Working

If autocomplete doesn't work inside Angular 17+ control flow blocks:

**Check Angular version:**
```bash
# Verify you're using Angular 17+
ng version

# Check project Angular version
cat package.json | grep "@angular/core"

# Run diagnostic to see control flow support
:AngularDiagnostic
```

**Ensure Language Server supports control flow:**
```bash
# Update Angular Language Server to latest version
npm install -g @angular/language-server@latest

# Verify Language Server configuration
:lua print(vim.inspect(require('lspconfig').angularls.resolved_capabilities))
```

**Check template syntax:**
```html
<!-- ✅ Correct Angular 17+ syntax -->
@if (condition) {
  <div>Content</div>
} @else {
  <div>Alternative</div>
}

@for (item of items; track item.id) {
  <div>{{ item.name }}</div>
} @empty {
  <div>No items</div>
}

<!-- ❌ Old syntax (still works but limited IntelliSense) -->
<div *ngIf="condition">Content</div>
<div *ngFor="let item of items">{{ item.name }}</div>
```

**Force Language Server restart:**
```bash
# In Neovim
:LspRestart angularls

# Check if control flow is recognized
:AngularDiagnostic
```

#### Shift+K (Hover) Not Working in Templates

If `Shift+K` doesn't show hover information in complex templates (especially with `@defer`, `@if`, etc.):

**Quick fix:**
```bash
# In the problematic template file
:AngularRefresh

# This will:
# 1. Restart Angular Language Server
# 2. Force reanalysis of current template
# 3. Re-enable hover functionality
```

**Diagnostic steps:**
```bash
# 1. Check if Angular LS is attached to current buffer
:AngularDiagnostic

# Should show:
# ✓ Angular LS attached to current buffer
# ✓ Hover capability: enabled

# 2. Test hover on different elements:
# - Component properties: {{ userInfo }}
# - Methods: (click)="logout(true)"
# - Pipes: | async
# - Directives: *ngIf
# - Custom components: <mapal-menu-desktop>

# 3. If hover still doesn't work, check LSP logs
:LspLog
```

**Common causes:**
- **Complex template structure**: `@defer` blocks can confuse the parser
- **Mixed syntax**: Combining old (`*ngIf`) and new (`@if`) syntax
- **Large template files**: Performance issues with complex templates
- **Nested components**: Deep component hierarchies

**Workarounds:**
```bash
# 1. Use :AngularRefresh regularly in complex templates
# 2. Break large templates into smaller components
# 3. Use :LspRestart angularls if issues persist
# 4. Check :checkhealth vim.lsp for general LSP issues
```

#### Angular Language Server Not Starting

**For nvm users:**
```bash
# Check current nvm environment
echo $NVM_BIN
which node
which npm

# Check if Angular Language Server is installed in current nvm version
npm list -g @angular/language-server

# If not found, install in current nvm version
npm install -g @angular/language-server typescript

# Verify installation
ls -la $(npm config get prefix)/lib/node_modules/@angular/language-server/bin/ngserver
```

**For system npm users:**
```bash
# Check if Angular Language Server is installed
npm list -g @angular/language-server

# Reinstall if needed
npm install -g @angular/language-server typescript
```

**Debug Angular Language Server path detection:**
```bash
# In Neovim, run the built-in diagnostic command:
:AngularDiagnostic

# This will show:
# - Environment information (Node.js, npm, nvm)
# - Workspace type detection (Angular vs Nx)
# - Angular Language Server path resolution
# - Global npm package status
# - LSP server status

# Or manually check the path being used:
:lua print(vim.inspect(require('lspconfig').angularls.cmd()))
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

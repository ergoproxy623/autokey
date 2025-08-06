#!/bin/bash

# Kickstart.nvim for Angular Development - Setup Script
# This script installs all necessary dependencies for Angular development in Neovim

set -e

echo "🚀 Setting up Kickstart.nvim for Angular Development"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check Neovim
    if command_exists nvim; then
        NVIM_VERSION=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+')
        print_success "Neovim found: $NVIM_VERSION"
    else
        print_error "Neovim not found. Please install Neovim 0.10.0 or later."
        exit 1
    fi
    
    # Check Node.js
    if command_exists node; then
        NODE_VERSION=$(node --version)
        print_success "Node.js found: $NODE_VERSION"
    else
        print_error "Node.js not found. Please install Node.js 18.x or later."
        exit 1
    fi
    
    # Check npm
    if command_exists npm; then
        NPM_VERSION=$(npm --version)
        print_success "npm found: $NPM_VERSION"
    else
        print_error "npm not found. Please install npm."
        exit 1
    fi
    
    # Check git
    if command_exists git; then
        print_success "Git found"
    else
        print_error "Git not found. Please install Git."
        exit 1
    fi
}

# Install system dependencies
install_system_deps() {
    print_status "Installing system dependencies..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt; then
            # Ubuntu/Debian
            print_status "Detected Ubuntu/Debian system"
            sudo apt update
            sudo apt install -y build-essential curl unzip ripgrep fd-find
            print_success "System dependencies installed"
        elif command_exists dnf; then
            # Fedora
            print_status "Detected Fedora system"
            sudo dnf install -y gcc make curl unzip ripgrep fd-find
            print_success "System dependencies installed"
        elif command_exists pacman; then
            # Arch Linux
            print_status "Detected Arch Linux system"
            sudo pacman -S --noconfirm gcc make curl unzip ripgrep fd
            print_success "System dependencies installed"
        else
            print_warning "Could not detect package manager. Please install: build tools, curl, unzip, ripgrep, fd"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        print_status "Detected macOS system"
        if command_exists brew; then
            brew install curl unzip ripgrep fd
            print_success "System dependencies installed via Homebrew"
        else
            print_warning "Homebrew not found. Please install: curl, unzip, ripgrep, fd"
        fi
    else
        print_warning "Unknown OS. Please manually install: build tools, curl, unzip, ripgrep, fd"
    fi
}

# Install npm packages
install_npm_packages() {
    print_status "Installing npm packages globally..."
    
    # Check if nvm is available and source it
    if [ -f "$HOME/.nvm/nvm.sh" ]; then
        print_status "Detected nvm, sourcing nvm environment..."
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        print_success "nvm environment loaded"
    fi
    
    # Display current Node.js and npm info
    print_status "Using Node.js: $(node --version)"
    print_status "Using npm: $(npm --version)"
    print_status "Global npm prefix: $(npm config get prefix)"
    
    # Angular CLI and Language Server
    print_status "Installing Angular CLI..."
    npm install -g @angular/cli
    
    # Check if we should install Nx CLI
    if [ -f "nx.json" ] || [ -f "workspace.json" ]; then
        print_status "Nx workspace detected, installing Nx CLI..."
        npm install -g nx
    fi
    
    print_status "Installing Angular Language Server (latest for VSCode-like features)..."
    npm install -g @angular/language-server@latest
    
    print_status "Installing TypeScript..."
    npm install -g typescript
    
    # Formatters and Linters
    print_status "Installing Prettier..."
    npm install -g prettier
    
    print_status "Installing ESLint daemon..."
    npm install -g eslint_d
    
    # Additional language servers
    print_status "Installing TypeScript Language Server..."
    npm install -g typescript-language-server
    
    print_status "Installing VS Code Language Servers..."
    npm install -g vscode-langservers-extracted
    
    # Verify Angular Language Server installation
    local ngserver_path=$(npm list -g @angular/language-server --depth=0 --parseable 2>/dev/null)
    if [ -n "$ngserver_path" ]; then
        local ngserver_bin="$ngserver_path/bin/ngserver"
        if [ -f "$ngserver_bin" ]; then
            print_success "Angular Language Server installed at: $ngserver_bin"
        else
            print_warning "Angular Language Server package found but binary not at expected location"
        fi
    else
        print_warning "Could not verify Angular Language Server installation"
    fi
    
    print_success "npm packages installed"
}

# Backup existing Neovim configuration
backup_config() {
    print_status "Backing up existing Neovim configuration..."
    
    if [ -d "$HOME/.config/nvim" ]; then
        BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$HOME/.config/nvim" "$BACKUP_DIR"
        print_success "Existing config backed up to: $BACKUP_DIR"
    fi
    
    if [ -d "$HOME/.local/share/nvim" ]; then
        BACKUP_DIR="$HOME/.local/share/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$HOME/.local/share/nvim" "$BACKUP_DIR"
        print_success "Existing data backed up to: $BACKUP_DIR"
    fi
}

# Install Neovim configuration
install_config() {
    print_status "Installing Neovim configuration..."
    
    # Create config directory
    mkdir -p "$HOME/.config/nvim"
    
    # Copy init.lua
    if [ -f "./init.lua" ]; then
        cp "./init.lua" "$HOME/.config/nvim/init.lua"
        print_success "Configuration installed to ~/.config/nvim/init.lua"
    else
        print_error "init.lua not found in current directory"
        exit 1
    fi
}

# Install fonts (optional)
install_fonts() {
    print_status "Would you like to install a Nerd Font for better icons? (y/n)"
    read -r install_font
    
    if [[ $install_font == "y" || $install_font == "Y" ]]; then
        print_status "Installing JetBrains Mono Nerd Font..."
        
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        
        # Download and install JetBrains Mono Nerd Font
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        TEMP_DIR=$(mktemp -d)
        
        curl -L "$FONT_URL" -o "$TEMP_DIR/JetBrainsMono.zip"
        unzip -q "$TEMP_DIR/JetBrainsMono.zip" -d "$TEMP_DIR"
        cp "$TEMP_DIR"/*.ttf "$FONT_DIR/"
        
        # Update font cache
        if command_exists fc-cache; then
            fc-cache -fv
        fi
        
        rm -rf "$TEMP_DIR"
        print_success "JetBrains Mono Nerd Font installed"
        print_warning "Please set your terminal to use 'JetBrainsMono Nerd Font' for best experience"
    fi
}

# Main installation process
main() {
    echo ""
    print_status "Starting installation process..."
    echo ""
    
    # Run installation steps
    check_prerequisites
    echo ""
    
    install_system_deps
    echo ""
    
    install_npm_packages
    echo ""
    
    backup_config
    echo ""
    
    install_config
    echo ""
    
    install_fonts
    echo ""
    
    print_success "Installation completed successfully!"
    echo ""
    print_status "Next steps:"
    echo "1. Start Neovim: nvim"
    echo "2. Wait for plugins to install (this may take a few minutes)"
    echo "3. Check installation with: :checkhealth"
    echo "4. Navigate to an Angular project and start coding!"
    echo ""
    print_status "Key bindings:"
    echo "- <Space> is the leader key"
    echo "- <Space>sf to search files"
    echo "- <Space>ac to generate Angular component"
    echo "- <Ctrl-n> to toggle file tree"
    echo "- gd to go to definition"
    echo ""
    print_status "For more information, check the README.md file"
    echo ""
    print_success "Happy coding with Angular and Neovim! 🚀"
}

# Run main function
main "$@"
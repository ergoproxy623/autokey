#!/bin/bash

# Test script for Neovim Angular LSP Configuration

echo "🔧 Testing Neovim Angular LSP Configuration..."
echo

# Check Neovim version
echo "📋 Neovim version:"
nvim --version | head -3
echo

# Check if language servers are available
echo "🌐 Language Servers:"
echo -n "Angular Language Server: "
if command -v ngserver &> /dev/null; then
    echo "✅ Available"
else
    echo "❌ Not found"
fi

echo -n "TypeScript Language Server: "
if command -v typescript-language-server &> /dev/null; then
    echo "✅ Available"
else
    echo "❌ Not found"
fi

echo -n "Node.js: "
if command -v node &> /dev/null; then
    echo "✅ $(node --version)"
else
    echo "❌ Not found"
fi

echo -n "npm: "
if command -v npm &> /dev/null; then
    echo "✅ $(npm --version)"
else
    echo "❌ Not found"
fi
echo

# Check configuration files
echo "📁 Configuration Files:"
config_dir="$HOME/.config/nvim"

if [ -f "$config_dir/init.lua" ]; then
    echo "✅ init.lua found"
else
    echo "❌ init.lua missing"
fi

if [ -f "$config_dir/lua/settings.lua" ]; then
    echo "✅ settings.lua found"
else
    echo "❌ settings.lua missing"
fi

if [ -f "$config_dir/lua/plugins.lua" ]; then
    echo "✅ plugins.lua found"
else
    echo "❌ plugins.lua missing"
fi

if [ -f "$config_dir/lua/lsp.lua" ]; then
    echo "✅ lsp.lua found"
else
    echo "❌ lsp.lua missing"
fi

if [ -f "$config_dir/lua/keymaps.lua" ]; then
    echo "✅ keymaps.lua found"
else
    echo "❌ keymaps.lua missing"
fi

if [ -f "$config_dir/lua/autocommands.lua" ]; then
    echo "✅ autocommands.lua found"
else
    echo "❌ autocommands.lua missing"
fi

echo
echo "🎉 Configuration test complete!"
echo
echo "📖 To get started:"
echo "1. Open an Angular project: cd /path/to/angular-project"
echo "2. Start Neovim: nvim ."
echo "3. Let plugins install automatically"
echo "4. Run :Mason to verify language servers"
echo "5. Run :LspInfo to check LSP status"
echo
echo "📚 See ~/.config/nvim/README.md for detailed usage instructions"
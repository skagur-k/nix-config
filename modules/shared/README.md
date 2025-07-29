# Shared Modules

This directory contains cross-platform configuration modules that can be used across different systems (macOS, Linux, etc.).

## Overview

The shared modules provide a consistent development environment and tooling across all systems. This includes shell configuration, development tools, and application configurations that work universally.

## 🎯 Key Features

- **Cross-Platform Compatibility**: Works on macOS, Linux, and other Unix-like systems
- **Consistent Development Environment**: Same tools and configurations everywhere
- **Modular Design**: Easy to enable/disable specific features
- **Version Controlled**: All configurations are declarative and reproducible

## 📁 Layout

```
.
├── config/              # Static configuration files
│   ├── helix/          # Helix editor configuration
│   │   └── config.toml # Editor settings, themes, keybindings
│   ├── starship/       # Shell prompt configuration
│   │   └── starship.toml # Prompt customization
│   ├── zellij/         # Terminal multiplexer configuration
│   │   └── zellij.kdl  # Layout and theme settings
│   └── zsh/            # Shell configuration
│       ├── aliases.zsh # Shell aliases and shortcuts
│       └── functions.zsh # Custom shell functions
├── default.nix         # Module definition and imports
├── files.nix          # File deployment configuration
├── home-manager.nix   # User programs and shell configuration
└── packages.nix       # Shared package definitions
```

## 🔧 Configuration Components

### Shell Configuration (`config/zsh/`)
- **aliases.zsh**: Common shell aliases for development and system management
- **functions.zsh**: Custom shell functions including zoxide helpers

### Editor Configuration (`config/helix/`)
- **config.toml**: Helix editor settings with modern theme and keybindings
- Includes syntax highlighting, LSP support, and performance optimizations

### Terminal Configuration (`config/zellij/`)
- **zellij.kdl**: Terminal multiplexer layout and theme configuration
- Auto-start configuration for seamless terminal experience

### Prompt Configuration (`config/starship/`)
- **starship.toml**: Fast, customizable shell prompt
- Git integration, language indicators, and system information

## 📦 Package Management (`packages.nix`)

### Development Tools
- **Helix**: Modern modal text editor
- **Git**: Version control with enhanced configuration
- **Ripgrep**: Fast text search
- **FZF**: Fuzzy finder
- **Eza**: Modern ls replacement

### Shell Enhancements
- **Zsh**: Enhanced shell with plugins
- **Starship**: Fast shell prompt
- **Zoxide**: Smart directory navigation
- **Zellij**: Terminal multiplexer

### System Utilities
- **Bat**: Syntax-highlighting cat
- **Btop**: System monitoring
- **Tree**: Directory tree visualization
- **Jq**: JSON processor

## 🚀 Usage

### Importing Shared Modules

```nix
# In your system configuration
imports = [
  ./modules/shared
];
```

### Customizing Configuration

1. **Modify existing configs**: Edit files in `config/` directories
2. **Add new packages**: Update `packages.nix`
3. **Customize shell**: Edit `home-manager.nix` or `config/zsh/` files
4. **Add new tools**: Create new config directories and update `files.nix`

### File Deployment

The `files.nix` module handles deployment of static configuration files to the appropriate locations:
- Shell configs → `~/.config/zsh/`
- Editor configs → `~/.config/helix/`
- Terminal configs → `~/.config/zellij/`
- Prompt configs → `~/.config/starship.toml`

## 🔄 Workflow

### Making Changes

1. **Edit configuration files** in the appropriate `config/` directory
2. **Update deployment** in `files.nix` if adding new files
3. **Test changes**:
   ```bash
   nix build .#darwinConfigurations.aarch64-darwin.system
   ```
4. **Apply changes**:
   ```bash
   nix run .#build-switch
   ```

### Adding New Applications

1. **Create config directory**: `config/new-app/`
2. **Add configuration file**: `config/new-app/config.toml`
3. **Update files.nix**: Add deployment entry
4. **Rebuild and apply**: `nix run .#build-switch`

## 🎨 Themes and Customization

### Color Schemes
- **Catppuccin Mocha**: Primary theme used across applications
- **Consistent styling**: Same colors and fonts across all tools

### Fonts
- **JetBrains Mono**: Primary programming font
- **Nerd Fonts**: Icons and symbols support

## 🔗 Related Documentation

- [Helix Documentation](https://docs.helix-editor.com/)
- [Starship Documentation](https://starship.rs/)
- [Zellij Documentation](https://zellij.dev/)
- [Zoxide Documentation](https://github.com/ajeetdsouza/zoxide)

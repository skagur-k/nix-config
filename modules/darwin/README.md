# macOS (Darwin) Modules

This directory contains macOS-specific configuration modules using nix-darwin. These modules provide system-level configuration, user management, and macOS-specific applications.

## Overview

The Darwin modules handle all macOS-specific configuration including system settings, Homebrew integration, user management, and application configurations that are unique to macOS.

## 🎯 Key Features

- **System Configuration**: macOS-specific system settings and defaults
- **Homebrew Integration**: Package and cask management
- **User Management**: User accounts, shells, and permissions
- **Application Configuration**: macOS-specific app configs (Ghostty, LeaderKey)
- **File Deployment**: Static configuration file management

## 📁 Layout

```
.
├── casks.nix          # Homebrew cask definitions
├── config/            # macOS-specific application configurations
│   ├── ghostty/       # Ghostty terminal configuration
│   │   └── config     # Terminal settings and theme
│   └── leaderkey/     # LeaderKey launcher configuration
│       └── config.toml # Launcher settings and keybindings
├── default.nix        # Module definition (imports other modules)
├── files.nix          # Static file deployment configuration
├── home-manager.nix   # User configuration and home-manager setup
└── packages.nix       # macOS-specific package definitions
```

## 🔧 Configuration Components

### System Configuration (`default.nix`)
- **User Management**: User accounts and permissions
- **System Defaults**: macOS system preferences
- **Environment Setup**: System-wide environment variables
- **Security Settings**: File permissions and security configurations

### Homebrew Integration (`casks.nix`)
- **Application Casks**: macOS applications via Homebrew
- **Font Management**: Programming fonts and icon fonts
- **Development Tools**: macOS-specific development applications

### Application Configurations (`config/`)

#### Ghostty Terminal (`config/ghostty/`)
- **config**: Terminal emulator configuration
- Modern GPU-accelerated terminal with Catppuccin theme
- macOS-specific optimizations and keybindings

#### LeaderKey (`config/leaderkey/`)
- **config.toml**: Application launcher configuration
- Fuzzy search and modern UI with consistent theming
- macOS-specific integration and shortcuts

### User Configuration (`home-manager.nix`)
- **Home Manager Setup**: User-level configuration management
- **Package Installation**: User-specific packages
- **File Deployment**: User configuration files
- **Backup Management**: Automatic backup of existing configurations

### Package Management (`packages.nix`)
- **macOS-specific packages**: Tools that work best on macOS
- **Development tools**: macOS-optimized development utilities
- **System utilities**: macOS-specific system management tools

## 🚀 Usage

### System Configuration

The Darwin modules are automatically imported by the main system configuration:

```nix
# In hosts/darwin/default.nix
imports = [
  ../../modules/darwin/home-manager.nix
  ../../modules/shared
];
```

### Adding macOS Applications

1. **Add to casks.nix**:
   ```nix
   # For GUI applications
   "application-name" = "latest";
   ```

2. **Add to packages.nix**:
   ```nix
   # For command-line tools
   package-name
   ```

### Customizing Application Configs

1. **Edit existing configs**: Modify files in `config/` directories
2. **Add new app configs**: Create new directories and add to `files.nix`
3. **Update deployment**: Ensure new configs are deployed via `files.nix`

## 🔄 Workflow

### Making Changes

1. **Edit configuration files** in the appropriate module
2. **Test the configuration**:
   ```bash
   nix build .#darwinConfigurations.aarch64-darwin.system
   ```
3. **Apply changes**:
   ```bash
   nix run .#build-switch
   ```

### Adding New Applications

1. **Create config directory**: `config/new-app/`
2. **Add configuration file**: `config/new-app/config.toml`
3. **Update files.nix**: Add deployment entry
4. **Rebuild and apply**: `nix run .#build-switch`

## 🎨 macOS-Specific Features

### System Integration
- **Transparent titlebars**: Modern window styling
- **macOS shortcuts**: Native keyboard shortcuts
- **System fonts**: Integration with macOS font system
- **Dark mode**: Automatic theme switching

### Performance Optimizations
- **GPU acceleration**: Hardware-accelerated rendering
- **Native APIs**: Direct macOS API integration
- **Efficient resource usage**: Optimized for macOS

## 🔗 Related Documentation

- [nix-darwin Documentation](https://daiderd.com/nix-darwin/manual/index.html)
- [Homebrew Documentation](https://docs.brew.sh/)
- [Ghostty Documentation](https://docs.ghostty.dev/)
- [LeaderKey Documentation](https://github.com/JoshuaBatty/leaderkey)

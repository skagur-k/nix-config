# NixOS Configuration for macOS

A comprehensive NixOS configuration for macOS using nix-darwin. This configuration provides a declarative, reproducible setup with modern development tools, terminal customization, and system management.

## �� Features

- **Declarative Configuration**: All system settings, packages, and configurations are defined in Nix
- **Cross-Platform**: Shared modules work across macOS systems
- **Modern Development Stack**: Includes tools like Helix, Zellij, Starship, and more
- **Smart Directory Navigation**: Zoxide integration for intelligent directory jumping
- **Terminal Customization**: Ghostty terminal with modern theming
- **Application Launcher**: LeaderKey for quick app launching
- **Package Management**: Homebrew integration for macOS-specific packages
- **Version Control**: Git configuration with sensible defaults

## 📁 Project Structure

```
nixos-config/
├── README.md                 # This file
├── flake.nix                # Main flake configuration
├── flake.lock               # Locked dependencies
├── apps/                    # Build and deployment scripts
│   ├── aarch64-darwin/     # Apple Silicon scripts
│   └── x86_64-darwin/      # Intel Mac scripts
├── hosts/                   # System-specific configurations
│   └── darwin/             # macOS host configuration
├── modules/                 # Reusable configuration modules
│   ├── darwin/             # macOS-specific modules
│   │   ├── config/         # App configurations (Ghostty, LeaderKey)
│   │   ├── casks.nix       # Homebrew casks
│   │   ├── files.nix       # Static file deployment
│   │   ├── home-manager.nix # User configuration
│   │   └── packages.nix    # macOS-specific packages
│   └── shared/             # Cross-platform modules
│       ├── config/         # Shared app configurations
│       │   ├── helix/      # Helix editor config
│       │   ├── starship/   # Shell prompt config
│       │   ├── zellij/     # Terminal multiplexer config
│       │   └── zsh/        # Shell configuration
│       ├── files.nix       # Shared file deployment
│       ├── home-manager.nix # Shared user programs
│       └── packages.nix    # Shared packages
└── overlays/               # Nix overlays for custom packages
```

## 🛠️ Prerequisites

### macOS
- **macOS** (Apple Silicon or Intel)
- **Nix** with flakes enabled
- **Git**



### Installing Nix

```bash
# Install Nix with Determinate Systems installer (recommended)
curl --proto '=https' --tlsv1.2 -sSf https://install.determinate.systems/nix | sh

# Or install with official installer
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### Enable Flakes

Add to your shell configuration:
```bash
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## 🚀 Quick Start

### macOS
1. **Clone the repository**:
   ```bash
   git clone <your-repo-url> nixos-config
   cd nixos-config
   ```

2. **Apply user information**:
   ```bash
   just apply
   ```

3. **Build and switch to the configuration**:
   ```bash
   just switch
   ```

**Alternative using traditional Nix commands:**
```bash
nix run .#apply
nix run .#build-switch
```



## 📋 Available Commands

### Using Justfile (Recommended)
The project includes a `justfile` for simplified command management. Run `just --list` to see all available commands.

**Quick Commands:**
- `just switch` - Build and switch to new configuration
- `just apply` - Apply user information (interactive)
- `just rollback` - Rollback to previous generation
- `just check` - Check system configuration
- `just update` - Update flake inputs
- `just clean` - Clean build artifacts
- `just help` - Show detailed help

**Development Commands:**
- `just fmt` - Format Nix files
- `just lint` - Lint Nix files
- `just diff` - Show configuration diff
- `just backup` - Backup current configuration
- `just restore <path>` - Restore from backup

### Traditional Nix Commands
- `nix run .#build` - Build configuration (test only)
- `nix run .#build-switch` - Build and switch to new configuration
- `nix run .#apply` - Apply user information
- `nix run .#rollback` - Rollback to previous generation



### Development
- `nix run .#check-keys` - Check SSH keys
- `nix run .#copy-keys` - Copy SSH keys
- `nix run .#create-keys` - Create SSH keys

## 🔧 Configuration Workflow

### Making Changes

1. **Edit configuration files** in the appropriate modules
2. **Test the configuration**:
   ```bash
   just build
   ```
3. **Apply changes**:
   ```bash
   just switch
   ```

**Alternative using traditional Nix commands:**
```bash
nix build .#darwinConfigurations.aarch64-darwin.system
nix run .#build-switch
```

### Common Change Scenarios

#### Adding a Package
1. Add to `modules/shared/packages.nix` (shared) or `modules/darwin/packages.nix` (macOS-only)
2. Run `just switch`

#### Adding App Configuration
1. Create config file in `modules/darwin/config/app-name/`
2. Add to `modules/darwin/files.nix` to deploy it
3. Run `just switch`

#### Modifying Shell Configuration
1. Edit files in `modules/shared/config/zsh/`
2. Run `just switch`

## 🎨 Included Applications

### Terminal & Shell
- **Ghostty**: Modern GPU-accelerated terminal (macOS)
- **Zellij**: Terminal multiplexer with auto-start
- **Zsh**: Enhanced shell with autosuggestions and syntax highlighting
- **Starship**: Fast, customizable shell prompt

### Development Tools
- **Helix**: Modern modal text editor
- **Git**: Version control with sensible defaults
- **FZF**: Fuzzy finder
- **Zoxide**: Smart directory navigation
- **Ripgrep**: Fast text search
- **Eza**: Modern ls replacement

### System Tools
- **Homebrew**: Package manager for macOS
- **LeaderKey**: Application launcher (macOS)
- **Docker**: Container platform
- **Various fonts**: Programming fonts including JetBrains Mono

## �� Troubleshooting

### Common Issues

#### Build Errors
```bash
# Check for syntax errors
nix flake check

# Build with verbose output
nix build .#darwinConfigurations.aarch64-darwin.system --verbose
```

#### Rollback
```bash
# Rollback to previous working configuration
nix run .#rollback
```

#### File Conflicts
If you get file conflict errors, existing files are automatically backed up with `.backup` extension.

### Homebrew Warnings
The warning `'install' is a deprecated alias for 'add'` is from Homebrew itself and doesn't affect functionality. It can be suppressed by updating nix-homebrew to the latest version.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `nix build`
5. Submit a pull request

## 📄 License

This configuration is provided as-is for personal use. Feel free to adapt it for your own needs.

## 🔗 Resources

- [nix-darwin Documentation](https://daiderd.com/nix-darwin/manual/index.html)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Package Search](https://search.nixos.org/)


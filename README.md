# Nix Configuration for macOS and Linux (WSL2)

A comprehensive NixOS configuration for macOS using nix-darwin and Linux using home-manager. This configuration provides a declarative, reproducible setup for both platforms with modern development tools, terminal customization, secrets management, and system automation.

> **Note**: This configuration is personalized for my setup (user: skagur). You'll need to modify user information, host configurations, and preferences before installation.

## 📖 Table of Contents

- [Features](#-features)
- [Project Structure](#-project-structure) 
- [Prerequisites](#️-prerequisites)
- [Installation Instructions](#-installation-instructions)
- [What to Expect](#️-what-to-expect)
- [First Time Setup](#-first-time-setup)
- [Available Commands](#-available-commands)
- [Configuration Workflow](#-configuration-workflow)
- [Included Applications](#-included-applications)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [Resources](#-resources)

## 📎 Features

- **Declarative Configuration**: All system settings, packages, and configurations are defined in Nix
- **Cross-Platform**: Shared modules work across macOS and Linux (WSL2)
- **Multiple Host Support**: Configurations for personal MacBook (skagur-mba), work MacBook (darwin-otsk), and WSL2
- **Secrets Management**: SOPS-nix integration for secure handling of SSH keys and sensitive data
- **Modern Development Stack**: Includes tools like Helix, Zellij, Starship, and more
- **Smart Directory Navigation**: Zoxide integration for intelligent directory jumping
- **Terminal Customization**: Ghostty terminal with modern theming (macOS)
- **Application Launcher**: LeaderKey for quick app launching (macOS)
- **Package Management**: Homebrew integration for macOS-specific packages
- **Version Control**: Git configuration with sensible defaults
- **Automated Scripts**: Kubernetes config encryption/decryption and setup automation

## 📁 Project Structure

```
nix-config/
├── README.md                 # This file
├── flake.nix                # Main flake configuration with inputs and outputs
├── flake.lock               # Locked dependencies
├── justfile                 # Task runner with common commands
├── .sops.yaml              # SOPS configuration for secrets management
├── apps/                    # Build and deployment scripts (per architecture)
│   ├── aarch64-darwin/     # Apple Silicon scripts (apply, build, rollback, etc.)
│   ├── x86_64-darwin/      # Intel Mac scripts (with key management)
│   └── x86_64-linux/       # Linux (WSL2) scripts
├── docs/                    # Documentation
│   └── setting-up-work-machine-wsl2.md
├── hosts/                   # System-specific configurations
│   ├── darwin-otsk/        # Work MacBook configuration
│   ├── skagur-mba/         # Personal MacBook configuration
│   └── wsl2/               # Linux WSL2 configuration
├── modules/                 # Reusable configuration modules
│   ├── darwin/             # Personal macOS-specific modules
│   │   ├── config/         # App configurations (Ghostty, LeaderKey)
│   │   ├── casks.nix       # Homebrew casks
│   │   ├── files.nix       # Static file deployment
│   │   ├── home-manager.nix # User configuration
│   │   └── packages.nix    # macOS-specific packages
│   ├── darwin-otsk/        # Work macOS-specific modules
│   │   ├── files.nix       # Work-specific file deployment
│   │   ├── home-manager.nix # Work user configuration
│   │   └── packages.nix    # Work-specific packages
│   ├── linux/              # Linux-specific modules
│   │   ├── config/         # Linux app configurations (zsh)
│   │   ├── files.nix       # Static file deployment
│   │   ├── home-manager.nix # User configuration with SSH setup
│   │   └── packages.nix    # Linux-specific packages
│   └── shared/             # Cross-platform modules
│       ├── config/         # Shared app configurations
│       │   ├── helix/      # Helix editor config
│       │   ├── k9s/        # Kubernetes CLI config
│       │   ├── starship/   # Shell prompt config
│       │   ├── zellij/     # Terminal multiplexer config
│       │   └── zsh/        # Shell configuration (aliases, env, functions)
│       ├── default.nix     # Shared module entry point
│       ├── files.nix       # Shared file deployment
│       ├── home-manager.nix # Shared user programs and settings
│       └── packages.nix    # Shared packages
├── overlays/               # Nix overlays for custom packages
├── scripts/                # Utility scripts
│   ├── decrypt-kubeconfig.sh # Kubernetes config decryption
│   ├── encrypt-kubeconfig.sh # Kubernetes config encryption
│   ├── generate-brewfile.sh  # Homebrew bundle generation
│   └── setup-git-hooks.sh    # Git hooks setup
└── secrets/                # Encrypted secrets and keys
    ├── README.md           # Secrets documentation
    ├── age-public.txt      # Public age key for encryption
    ├── kubeconfig.enc.yaml # Encrypted Kubernetes config
    └── secrets.yaml        # SOPS-encrypted secrets file
```

## 🛠️ Prerequisites

### System Requirements

**macOS:**
- macOS 10.15+ (Catalina or later)
- Apple Silicon (M1/M2/M3) or Intel processor
- Admin privileges (for system configuration)

**Linux (WSL2):**
- Windows 10/11 with WSL2 enabled
- Ubuntu 20.04+ distribution in WSL2
- At least 4GB available disk space

### Step 1: Install Nix

Choose one of the following methods to install Nix:

#### Option A: Determinate Systems Installer (Recommended)
```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.determinate.systems/nix | sh
```
*This installer automatically enables flakes and configures Nix optimally.*

#### Option B: Official Nix Installer
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**Then enable flakes:**
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Step 2: Restart Your Shell
```bash
# Source the Nix environment
source ~/.nix-profile/etc/profile.d/nix.sh

# Or open a new terminal session
```

### Step 3: Verify Installation
```bash
# Check Nix version
nix --version

# Test flakes are enabled
nix flake --help
```

## 🚀 Installation Instructions

### Step 1: Clone the Repository

```bash
# Clone to your home directory (update with your fork if you've forked it)
git clone https://github.com/skagur-k/nix-config.git ~/nix-config
cd ~/nix-config
```

### Step 2: Customize User Information

**Important**: You must update the user information before installation.

Edit the user variables in the appropriate modules:
```bash
# For shared configuration
$EDITOR modules/shared/home-manager.nix

# For Linux-specific configuration  
$EDITOR modules/linux/home-manager.nix

# Update the user variable (currently set to "skagur")
user = "your-username";

# Also update git configuration in shared/home-manager.nix
programs.git = {
  userName = "Your Full Name";
  userEmail = "your.email@example.com";
};
```

### Step 3: Choose Your Installation Method

#### Method A: Using Just (Recommended)

```bash
# Install just if not available
nix profile install nixpkgs#just

# See all available commands
just --list

# Apply configuration (builds and switches)
just switch

# For work MacBook (OTSK configuration)
just switch-otsk
```

#### Method B: Using Nix Commands Directly

**For macOS (Personal - skagur-mba):**
```bash
# Apple Silicon Macs
nix run .#build-switch

# Intel Macs  
nix run .#build-switch --system x86_64-darwin
```

**For macOS (Work - darwin-otsk):**
```bash
# Apple Silicon Macs
nix run .#build-switch-otsk

# Intel Macs
nix run .#build-switch-otsk --system x86_64-darwin
```

**For Linux (WSL2):**
```bash
nix run .#build-switch
```

### Step 4: Verify Installation

```bash
# Check that new packages are available
which helix zellij starship

# Start a new terminal session to load configurations
exec $SHELL
```

## ⏱️ What to Expect

**First installation typically takes:**
- macOS: 15-30 minutes (includes Homebrew apps)
- Linux: 10-20 minutes

**During installation you'll see:**
1. Package downloads and compilation
2. Homebrew installation (macOS only)
3. Configuration file deployment
4. System activation

**After installation:**
- New terminal sessions will use the configured shell
- Applications will be available in your PATH
- Configuration files will be symlinked to your home directory

## 🎯 First Time Setup

After successful installation, here's what to do next:

### 1. Open a New Terminal
The configuration only applies to new terminal sessions:
```bash
# Start a fresh terminal or reload current session
exec $SHELL
```

### 2. Verify Everything Works
```bash
# Check shell prompt (should show Starship prompt)
echo "Shell configured: $SHELL"

# Test key applications
helix --version
starship --version
zellij --version

# Test git configuration
git config --get user.name
git config --get user.email
```

### 3. Explore Key Features
```bash
# Smart directory navigation
z ~/         # Navigate using zoxide
zi           # Interactive directory picker

# Terminal multiplexer 
zellij       # Start terminal multiplexer session

# Modern file listing
ll           # Enhanced ls with eza

# Git status checking (if in a git repo)
gs           # Git status alias
```

### 4. Customize Further (Optional)
- Edit shell aliases in `modules/shared/config/zsh/aliases.zsh`
- Modify prompt in `modules/shared/config/starship/starship.toml`
- Add packages in `modules/shared/packages.nix`
- Add apps (macOS) in `modules/darwin/casks.nix`

After making changes, run `just switch` to apply them.

### 5. Secrets Management (Optional)
This configuration includes SOPS-nix for secrets management:

```bash
# If you need to manage secrets, first install age and sops
nix profile install nixpkgs#age nixpkgs#sops

# Generate age key pair (for new setup)
age-keygen -o ~/.config/sops/age/keys.txt

# Encrypt new secrets
sops secrets/secrets.yaml

# The configuration automatically handles:
# - SSH key deployment from encrypted secrets
# - Kubernetes config encryption/decryption via scripts
```

## 📋 Available Commands

### Using Justfile (Recommended)
The project includes a `justfile` for simplified command management. Run `just --list` to see all available commands.

**Core Commands:**
- `just switch` - Build and switch to new configuration
- `just switch-otsk` - Build and switch for work MacBook (OTSK)
- `just build` - Build configuration (test only)
- `just apply` - Apply user information (interactive)
- `just rollback` - Rollback to previous generation

**System Management:**
- `just update` - Update flake inputs
- `just check` - Check system configuration  
- `just info` - Show system information
- `just clean` - Clean build artifacts
- `just deps` - Show flake dependencies

**Development:**
- `just dev` - Enter development shell
- `just fmt` - Format Nix files
- `just help` - Show detailed help with examples

**Homebrew Management (macOS):**
- `just brewfile` - Generate Brewfile from casks.nix
- `just setup-hooks` - Setup git hooks for auto-Brewfile generation
- `just brew-install` - Install apps from ~/.config/Brewfile

### Traditional Nix Commands

**Build Commands:**
- `nix run .#build` - Build configuration (test only)
- `nix run .#build-switch` - Build and switch to new configuration (personal)
- `nix run .#build-switch-otsk` - Build and switch for work MacBook

**Management Commands:**
- `nix run .#apply` - Apply user information
- `nix run .#rollback` - Rollback to previous generation

**Key Management (Intel macOS only):**
- `nix run .#check-keys` - Check SSH keys
- `nix run .#copy-keys` - Copy SSH keys
- `nix run .#create-keys` - Create SSH keys

## �️ Host Configurations

This configuration supports multiple machines with specialized setups:

### Personal MacBook (skagur-mba)
- **Target**: Personal development and daily use
- **Features**: Full application suite, personal SSH keys, development tools
- **Build command**: `just switch` or `nix run .#build-switch`

### Work MacBook (darwin-otsk) 
- **Target**: Work environment with specialized tooling
- **Features**: Work-specific packages, separate SSH configuration, OTSK-specific settings
- **Build command**: `just switch-otsk` or `nix run .#build-switch-otsk`

### Linux WSL2 (wsl2)
- **Target**: Development environment in Windows WSL2
- **Features**: Linux-specific packages, WSL environment variables, SSH configuration
- **Build command**: `just switch` or `nix run .#build-switch`
- **Documentation**: See `docs/setting-up-work-machine-wsl2.md` for setup details

Each host configuration includes:
- Host-specific package lists
- Environment-specific file deployments  
- SSH key management via SOPS
- Tailored application configurations

## 🔐 Secrets Management

This configuration uses SOPS-nix for secure secrets management:

### Features
- **SSH Keys**: Automatically deployed from encrypted secrets
- **Age Encryption**: Used for secrets encryption/decryption
- **Kubernetes Config**: Encrypted kubeconfig with helper scripts
- **Per-Host Keys**: Different keys for different environments

### Key Files
- `secrets/secrets.yaml` - Main encrypted secrets file
- `secrets/age-public.txt` - Public age key for encryption
- `secrets/kubeconfig.enc.yaml` - Encrypted Kubernetes configuration
- `scripts/encrypt-kubeconfig.sh` - Encrypt Kubernetes config
- `scripts/decrypt-kubeconfig.sh` - Decrypt Kubernetes config

### Setup
```bash
# Generate age key (first time setup)
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Add public key to secrets/age-public.txt
# Edit secrets
sops secrets/secrets.yaml
```

## �🔧 Configuration Workflow

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

### Kubernetes & DevOps
- **K9s**: Kubernetes CLI dashboard with custom themes
- **kubectl**: Kubernetes command-line tool
- **Docker**: Container platform

### System Tools
- **Homebrew**: Package manager for macOS (with Brewfile generation)
- **LeaderKey**: Application launcher (macOS)
- **SOPS**: Secrets encryption/decryption
- **Age**: File encryption tool

### Security & SSH
- **SSH**: Configured with multiple identity files for different services
- **Age encryption**: For secrets management
- **Automatic SSH key deployment**: Via SOPS-encrypted secrets

### Fonts & Themes
- **JetBrains Mono**: Programming font
- **Custom terminal themes**: Including transparent K9s skin

## 🔧 Troubleshooting

### Installation Issues

#### "Flakes not enabled" Error
```bash
# Enable flakes and nix-command
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Restart your shell
exec $SHELL
```

#### Permission Denied (macOS)
```bash
# Ensure you have admin privileges
sudo echo "Testing sudo access"

# If using corporate macOS, you may need IT assistance
```

#### Git Authentication Issues
```bash
# Use HTTPS instead of SSH if you don't have keys set up
git clone https://github.com/YOUR_USERNAME/nix-config.git ~/nix-config
```

### Build Issues

#### Syntax Errors
```bash
# Check for configuration syntax errors
nix flake check

# Show detailed error output
nix run .#build-switch --verbose
```

#### Package Build Failures
```bash
# Update flake inputs
nix flake update

# Try building again
nix run .#build-switch
```

#### Disk Space Issues
```bash
# Clean up nix store
nix-collect-garbage -d

# Check available space
df -h
```

### Runtime Issues

### Runtime Issues

#### Configuration Not Loading
```bash
# Ensure you're using a new terminal session
exec $SHELL

# Check if home-manager activated
ls -la ~/.config/
```

#### Missing Commands
```bash
# Check if programs are in PATH
echo $PATH

# Reload nix environment
source ~/.nix-profile/etc/profile.d/nix.sh
```

#### SOPS/Secrets Issues
```bash
# Check if age key exists
ls -la ~/.config/sops/age/keys.txt

# Test SOPS decryption
sops --decrypt secrets/secrets.yaml

# Check SSH key deployment
ls -la ~/.ssh/

# Re-decrypt kubeconfig if needed
./scripts/decrypt-kubeconfig.sh
```

#### File Conflicts
If you get file conflict errors during installation:
- Existing files are automatically backed up with `.backup` extension
- Check `~/.config/*.backup` for your previous configurations
- Manually resolve conflicts if needed

### Recovery Options

#### Rollback to Previous Generation
```bash
# List available generations
nix run .#rollback --list

# Rollback to previous working configuration
nix run .#rollback
```

#### Reset to Clean State
```bash
# Remove all home-manager generations
home-manager generations | cut -d' ' -f7 | xargs rm -rf

# Remove nix profiles (nuclear option)
nix profile remove '.*'
```

### Common Warnings

#### Homebrew Deprecation Warning
The warning `'install' is a deprecated alias for 'add'` is from Homebrew itself and doesn't affect functionality.

#### Git Tree Uncommitted Changes
The warning about uncommitted changes is normal and indicates you have local modifications.

### Getting Help

1. Check the [NixOS Discourse](https://discourse.nixos.org/)
2. Search [GitHub Issues](https://github.com/NixOS/nixpkgs/issues)
3. Join the [NixOS Discord](https://discord.gg/RbvHtGa)
4. Check specific tool documentation in this repository

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch  
3. Make your changes
4. Test with `just build` or `nix build`
5. Format code with `just fmt`
6. Update documentation if needed
7. Submit a pull request

### Development Workflow
```bash
# Enter development shell
just dev

# Make changes to configuration files
# Test your changes
just build

# Format code
just fmt

# Apply and test
just switch
```

### Adding New Features
- **New packages**: Add to appropriate `packages.nix` file
- **New applications**: Add to `casks.nix` (macOS) or packages
- **New configurations**: Add config files and reference in `files.nix`
- **New hosts**: Create new host directory and update `flake.nix`

## 📄 License

This configuration is provided as-is for personal use. Feel free to adapt it for your own needs.

## 🔗 Resources

- [nix-darwin Documentation](https://daiderd.com/nix-darwin/manual/index.html)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Package Search](https://search.nixos.org/)


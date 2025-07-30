# WSL2 Ubuntu Host Configuration

This directory contains the main NixOS configuration for WSL2 Ubuntu environments.

## Configuration Overview

The `default.nix` file provides a complete NixOS configuration optimized for WSL2 Ubuntu, including:

### System Configuration
- **System State Version**: 23.11
- **Flakes**: Enabled with experimental features
- **Timezone**: UTC
- **Locale**: en_US.UTF-8
- **Console**: US keyboard layout with Terminus font

### User Configuration
- **Username**: skagur
- **Shell**: zsh
- **Groups**: wheel, networkmanager, audio, video, docker
- **Sudo**: Passwordless sudo for wheel group

### System Packages
- Essential development tools (vim, git, curl, wget)
- System monitoring (htop, tree, ripgrep, fd, bat)
- Terminal utilities (exa, fzf, tmux, neofetch)

### Services
- **SSH**: Enabled with key-based authentication only
- **Printing**: CUPS printing system
- **Bluetooth**: Blueman manager
- **NetworkManager**: Network management
- **Firewall**: Basic firewall with common ports (22, 80, 443)

### Security
- **Audit**: Audit daemon enabled
- **SSH Security**: Root login disabled, password auth disabled

### Boot Configuration
- **Systemd-boot**: UEFI bootloader
- **EFI Variables**: Can touch EFI variables

## Module Imports

The configuration imports:
- `../../modules/shared` - Shared modules across all systems
- `../../modules/wsl2-ubuntu` - WSL2-specific modules

## Usage

To apply this configuration:

```bash
# Build and switch
sudo nixos-rebuild switch --flake .#x86_64-linux

# Or use the convenience script
./apps/x86_64-linux/build-switch
```

## WSL2 Considerations

- This configuration is designed for WSL2 with systemd enabled
- GUI applications require X server setup on Windows
- Docker integration works with Docker Desktop for Windows
- Network configuration is optimized for WSL2 networking 
# WSL2 Ubuntu Modules

This directory contains NixOS modules specifically configured for WSL2 Ubuntu environments.

## Structure

- `default.nix` - Empty file (modules imported directly in host configuration)
- `packages.nix` - Home-manager packages configuration
- `system-packages.nix` - System packages configuration
- `home-manager.nix` - Home-manager configuration for WSL2
- `files.nix` - WSL2-specific file configurations

## Features

### System Packages
- Development tools (gcc, cmake, python3, nodejs, etc.)
- System utilities (htop, strace, lsof, etc.)
- Network tools (nmap, netcat, mtr, etc.)
- Container tools (docker, podman)
- Security tools (openssl, gnupg, pass)

### Home Manager Packages
- WSL2-specific tools (wslu, wslview)
- Additional development languages (rust, go, deno)
- Enhanced shell experience (zoxide, starship)

### WSL2 Specific Configuration
- WSL2 configuration file (`/etc/wsl.conf`)
- Environment variables for WSL2 integration
- Docker group membership for the user
- Display configuration for GUI applications

### Home Manager Integration
- WSL2-specific tools (wslu, wslview)
- Additional development languages (rust, go, deno)
- Enhanced shell experience (zoxide, starship)

## Usage

The WSL2 Ubuntu configuration is automatically included when building for `x86_64-linux` systems. Use the following commands:

```bash
# Build the configuration
nix build .#nixosConfigurations.x86_64-linux.config.system.build.toplevel

# Apply the configuration
sudo nixos-rebuild switch --flake .#x86_64-linux

# Or use the convenience scripts
./apps/x86_64-linux/build-switch
./apps/x86_64-linux/apply
./apps/x86_64-linux/rollback
```

## Notes

- This configuration assumes WSL2 with systemd enabled
- GUI applications require an X server on Windows (e.g., VcXsrv, X410)
- Docker integration requires Docker Desktop for Windows with WSL2 backend
- Some packages may need additional configuration for WSL2 compatibility 
# WSL2 Ubuntu Setup Guide

This guide will walk you through setting up WSL2 Ubuntu and applying the NixOS configuration from this repository.

## Prerequisites

- **Windows 10/11** (version 2004 or higher for WSL2)
- **Administrator access** on Windows
- **Git** installed on Windows (optional, but recommended)

## Step 1: Enable WSL2

### 1.1 Enable WSL Feature

Open PowerShell as Administrator and run:

```powershell
# Enable WSL feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Restart your computer when prompted.

### 1.2 Install WSL2 Kernel Update

Download and install the WSL2 Linux kernel update from Microsoft:
- [WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

### 1.3 Set WSL2 as Default

Open PowerShell as Administrator and run:

```powershell
wsl --set-default-version 2
```

## Step 2: Install Ubuntu

### 2.1 Install Ubuntu from Microsoft Store

1. Open the **Microsoft Store**
2. Search for "Ubuntu"
3. Install **Ubuntu** (latest LTS version recommended)
4. Launch Ubuntu from the Start menu
5. Create a username and password when prompted

### 2.2 Verify WSL2 Installation

In PowerShell, run:

```powershell
wsl --list --verbose
```

You should see Ubuntu running on WSL2 (version 2).

## Step 3: Update Ubuntu

Open Ubuntu and run:

```bash
# Update package list
sudo apt update

# Upgrade packages
sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl wget git
```

## Step 4: Install Nix

### 4.1 Install Nix with Determinate Systems Installer (Recommended)

```bash
# Install Nix with Determinate Systems installer
curl --proto '=https' --tlsv1.2 -sSf https://install.determinate.systems/nix | sh

# Restart your shell or source the profile
source /etc/profile.d/nix.sh
```

### 4.2 Alternative: Install with Official Installer

```bash
# Install Nix with official installer
sh <(curl -L https://nixos.org/nix/install) --daemon

# Restart your shell or source the profile
source /etc/profile.d/nix.sh
```

### 4.3 Verify Nix Installation

```bash
# Check Nix version
nix --version

# Test Nix
nix-shell -p hello --run hello
```

## Step 5: Enable Flakes

### 5.1 Create Nix Configuration Directory

```bash
# Create nix configuration directory
mkdir -p ~/.config/nix

# Create nix.conf file
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF
```

### 5.2 Restart Nix Daemon

```bash
# Restart nix daemon
sudo systemctl restart nix-daemon
```

## Step 6: Clone and Setup Configuration

### 6.1 Clone the Repository

```bash
# Clone the repository
git clone <your-repo-url> nixos-config
cd nixos-config
```

### 6.2 Verify Flake Configuration

```bash
# Check flake configuration
nix flake show

# You should see nixosConfigurations.x86_64-linux listed
```

## Step 7: Apply Configuration

### 7.1 Build Configuration (Test Only)

```bash
# Build the configuration to check for errors
nix build .#nixosConfigurations.x86_64-linux.config.system.build.toplevel
```

### 7.2 Apply Configuration

```bash
# Apply the configuration
sudo nixos-rebuild switch --flake .#x86_64-linux
```

### 7.3 Alternative: Use Convenience Scripts

```bash
# Make scripts executable
chmod +x apps/x86_64-linux/*

# Build and switch
./apps/x86_64-linux/build-switch

# Or apply only
./apps/x86_64-linux/apply
```

## Step 8: Post-Installation Setup

### 8.1 Restart Shell

```bash
# Restart your shell to load new configuration
exec zsh
```

### 8.2 Verify Installation

```bash
# Check that packages are installed
which zsh
which git
which docker

# Check home-manager
home-manager --version
```

### 8.3 Setup Git (if not already configured)

```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 9: WSL2-Specific Configuration

### 9.1 GUI Applications (Optional)

If you want to run GUI applications:

1. **Install VcXsrv on Windows**:
   - Download from [VcXsrv](https://sourceforge.net/projects/vcxsrv/)
   - Install and run XLaunch
   - Configure to allow connections from WSL2

2. **Configure DISPLAY in WSL2**:
   ```bash
   # Add to your shell profile
   echo 'export DISPLAY=:0' >> ~/.zshrc
   source ~/.zshrc
   ```

### 9.2 Docker Integration (Optional)

If you want to use Docker with Docker Desktop:

1. **Install Docker Desktop for Windows**
2. **Enable WSL2 Integration** in Docker Desktop settings
3. **Add your WSL2 distribution** to the integration list

### 9.3 Windows Integration

```bash
# Access Windows files
ls /mnt/c/

# Open Windows applications from WSL2
wslview notepad.exe
```

## Troubleshooting

### Common Issues

#### 1. WSL2 Not Starting
```powershell
# In PowerShell as Administrator
wsl --shutdown
wsl --update
```

#### 2. Nix Build Errors
```bash
# Clean Nix store
nix store gc

# Rebuild with verbose output
nix build .#nixosConfigurations.x86_64-linux.config.system.build.toplevel --verbose
```

#### 3. Permission Issues
```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.config/nix
```

#### 4. Flake Not Found
```bash
# Update flake inputs
nix flake update

# Lock flake
nix flake lock
```

#### 5. Home-manager Issues
```bash
# Rebuild home-manager
home-manager switch --flake .#x86_64-linux
```

### Rollback Configuration

If something goes wrong:

```bash
# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or use convenience script
./apps/x86_64-linux/rollback
```

## Useful Commands

### Configuration Management
```bash
# Build configuration
./apps/x86_64-linux/build

# Apply configuration
./apps/x86_64-linux/apply

# Rollback configuration
./apps/x86_64-linux/rollback

# Check system status
nixos-rebuild dry-activate --flake .#x86_64-linux
```

### Package Management
```bash
# Search for packages
nix search nixpkgs package-name

# Install packages temporarily
nix-shell -p package-name

# Install packages permanently (edit configuration files)
```

### System Information
```bash
# Check NixOS version
nixos-version

# List generations
nix-env --list-generations -p /nix/var/nix/profiles/system

# Check system packages
nix-env -qaP --installed
```

## Next Steps

1. **Customize the configuration** by editing files in `modules/wsl2-ubuntu/`
2. **Add your own packages** to `modules/wsl2-ubuntu/system-packages.nix`
3. **Configure your shell** by editing files in `modules/shared/config/zsh/`
4. **Set up additional services** as needed

## Resources

- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Search the [NixOS Wiki](https://nixos.wiki/)
3. Ask questions on [NixOS Discourse](https://discourse.nixos.org/)
4. Check the [WSL2 GitHub issues](https://github.com/microsoft/WSL/issues) 
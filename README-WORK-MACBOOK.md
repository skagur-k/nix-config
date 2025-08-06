# Work MacBook Configuration (No Sudo Required)

This configuration is specifically designed for work MacBooks where you don't have administrator/sudo privileges. It provides a complete development environment using only user-space configurations.

## Features

- ✅ **No sudo required** - All configurations work without administrator privileges
- ✅ **Home Manager integration** - Manages dotfiles and user configurations
- ✅ **Development tools** - Essential CLI tools and development packages
- ✅ **Shell configuration** - ZSH with starship, fzf, and productivity enhancements
- ❌ **No system settings** - System preferences must be configured manually
- ❌ **No Homebrew** - GUI applications need manual installation

## Quick Start

### Prerequisites

1. **Nix installed** - Install Nix using the Determinate Nix Installer:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Enable flakes** - If not already enabled:
   ```bash
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

### Installation

1. **Clone this repository**:
   ```bash
   git clone <your-repo-url> ~/nix-config
   cd ~/nix-config
   ```

2. **Apply the configuration**:
   ```bash
   nix run .#apply-otsk
   ```

   Or use the step-by-step approach:
   ```bash
   # Build the configuration
   nix run .#build-otsk
   
   # Apply the configuration
   nix run .#build-switch-otsk
   ```

### Available Commands

| Command | Description |
|---------|-------------|
| `nix run .#build-otsk` | Build the work MacBook configuration |
| `nix run .#build-switch-otsk` | Build and switch to the new configuration |
| `nix run .#apply-otsk` | Quick apply (build + switch) |
| `nix run .#rollback-otsk` | Rollback to previous generation |

## What's Included

### CLI Tools & Development
- **Shell**: zsh with starship prompt, fzf, zoxide
- **Editors**: helix, with git integration
- **Development**: kubectl, terraform, docker, awscli2, azure-cli
- **Utilities**: bat, eza, ripgrep, jq, htop, btop
- **Cloud Tools**: k9s, lazygit, google-cloud-sdk

### Configuration Files
- **Shell configuration**: ZSH aliases, functions, and environment
- **Git configuration**: Delta pager, sensible defaults
- **Helix editor**: Modern configuration
- **Starship prompt**: Beautiful shell prompt
- **K9s**: Kubernetes dashboard configuration

## Limitations (Due to No Sudo Access)

### Cannot Install
- ❌ GUI applications via Homebrew casks
- ❌ System-level fonts
- ❌ System preferences and defaults
- ❌ Applications that require installation to `/Applications`

### Manual Setup Required
1. **GUI Applications**: Install manually from websites or App Store
2. **System Preferences**: Configure manually in System Preferences
3. **Fonts**: Install manually by double-clicking font files
4. **Shell as default**: May need to change default shell in System Preferences

## Recommended Manual Installations

### Essential GUI Apps
- **VS Code**: Download from [code.visualstudio.com](https://code.visualstudio.com)
- **iTerm2**: Download from [iterm2.com](https://iterm2.com)
- **Browser**: Chrome, Firefox, etc.

### Optional Productivity Apps
- **Rectangle**: Window management
- **Alfred/Raycast**: Application launcher
- **Obsidian**: Note-taking

## Customization

### Adding Work-Specific Packages
Edit `modules/darwin-otsk/packages.nix`:
```nix
shared-packages
++ [
  # Add your work-specific packages here
  my-work-tool
  another-cli-tool
]
```

### Adding Work-Specific Configuration
Edit `modules/darwin-otsk/files.nix`:
```nix
{
  # Work-specific git config
  "${xdg_configHome}/git/config-work".text = ''
    [user]
      name = "Your Work Name"
      email = "your.work@company.com"
  '';
}
```

## Troubleshooting

### Permission Denied Errors
If you see permission errors, ensure you're not trying to modify system files. This configuration only manages user-space files.

### Missing Commands
If a command isn't found after installation:
1. Restart your shell: `exec zsh`
2. Check if it's in your PATH: `echo $PATH`
3. Verify the package is in your configuration

### Configuration Not Applied
If changes don't take effect:
1. Check for build errors: `nix run .#build-otsk`
2. Ensure you ran the switch command: `nix run .#build-switch-otsk`
3. Restart your shell to reload environment

## Alternative: Home Manager Only

If nix-darwin gives you trouble, you can use Home Manager directly:

```bash
# Install Home Manager
nix run home-manager/master -- switch --flake .#skagur-work
```

Create a Home Manager-only configuration in your flake.nix if needed.

## Support

For issues specific to this work configuration:
1. Check that you don't have any sudo requirements in your config
2. Verify all paths are user-writable
3. Ensure you're not trying to install system-level components

For general Nix issues, consult the [Nix documentation](https://nixos.org/manual/nix/stable/).

---

**Note**: This configuration is designed to be sudo-free and work-environment friendly. All system-level customizations must be done manually through System Preferences or other means available without administrator privileges.
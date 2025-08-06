# Justfile for NixOS Configuration Management
# Run 'just --list' to see all available commands

# Default target - show help
default:
    @just --list

# Helper function to get correct system name
# get_system:
#     if [[ "$(uname -s)" == "Darwin" ]]; then
#         if [[ "$(uname -m)" == "arm64" ]]; then
#             echo "aarch64-darwin"
#         elif [[ "$(uname -m)" == "x86_64" ]]; then
#             echo "x86_64-darwin"
#         else
#             echo "Unknown Darwin architecture: $(uname -m)"
#             exit 1
#         fi
#     elif [[ "$(uname -s)" == "Linux" ]]; then
#         if [[ "$(uname -m)" == "x86_64" ]]; then
#             echo "x86_64-linux"
#         else
#             echo "Unknown Linux architecture: $(uname -m)"
#             exit 1
#         fi
#     else
#         echo "Unsupported operating system: $(uname -s)"
#         exit 1
#     fi

# Build the configuration for the current system
build:
    @echo "Building NixOS configuration..."
    @nix run .#build

# Build and switch to the new configuration
switch:
    @echo "Building and switching to new configuration..."
    nix run .#build-switch

switch-otsk:
    @echo "Building and switching to new configuration... (OTSK)"
    nix run .#build-switch-otsk

# Apply configuration (runs the apply script)
apply:
    echo "Applying configuration..."
    nix run .#apply

# Rollback to previous configuration
rollback:
    @echo "Rolling back to previous configuration..."
    nix run .#rollback

# Check system configuration
check:
    @echo "Checking system configuration..."
    nix flake check

# Update flake inputs
update:
    @echo "Updating flake inputs..."
    nix flake update

# Show current system info
# info:
#     echo "System Information:"
#     echo "Architecture: $(uname -m)"
#     echo "OS: $(uname -s)"
#     echo "Hostname: $(hostname)"
#     echo "User: $(whoami)"
#     echo "Nix System: $(just get_system)"

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    rm -rf result
    nix store gc

# Show flake dependencies
deps:
    @echo "Flake dependencies:"
    nix flake show

# Enter development shell
dev:
    @echo "Entering development shell..."
    nix develop



# Format Nix files
fmt:
    @echo "Formatting Nix files..."
    nixpkgs-fmt **/*.nix

# Show configuration diff
# diff:
#     echo "Showing configuration diff..."
#   
#     if [[ "$SYSTEM" == *"darwin"* ]]; then
#         nix build .#darwinConfigurations.$SYSTEM.system --dry-run
#     elif [[ "$SYSTEM" == *"linux"* ]]; then
#         nix build .#nixosConfigurations.$SYSTEM.config.system.build.toplevel --dry-run
#     fi

# Backup current configuration
# backup:
#     echo "Creating backup..."
#     cp -r . ../nixos-config-backup-$(date +%Y%m%d-%H%M%S)

# Restore from backup (requires backup path)
# restore backup_path:
#     echo "Restoring from backup: {{backup_path}}"
#     if [ -d "{{backup_path}}" ]; then
#         cp -r {{backup_path}}/* .
#         echo "Restore completed"
#     else
#         echo "Backup path not found: {{backup_path}}"
#         exit 1
#     fi

# Show help with examples
help:
    @echo "NixOS Configuration Management Commands:"
    @echo ""
    @echo "  just build     - Build the configuration"
    @echo "  just switch    - Build and switch to new configuration"
    @echo "  just apply     - Apply configuration (interactive)"
    @echo "  just rollback  - Rollback to previous configuration"
    @echo "  just check     - Check system configuration"
    @echo "  just update    - Update flake inputs"
    @echo "  just info      - Show system information"
    @echo "  just clean     - Clean build artifacts"
    @echo "  just deps      - Show flake dependencies"
    @echo "  just dev       - Enter development shell"
    @echo "  just fmt       - Format Nix files"
    @echo "  just diff      - Show configuration diff"
    @echo "  just backup    - Backup current configuration"
    @echo "  just restore <path> - Restore from backup"
    @echo ""
    @echo "Brewfile Management:"
    @echo "  just brewfile        - Generate Brewfile from casks.nix"
    @echo "  just setup-hooks     - Setup git hooks (auto-generate Brewfile)"
    @echo "  just brew-install    - Install apps from ~/.config/Brewfile"
    @echo ""
    @echo "Supported Systems:"
    @echo "  macOS (Apple Silicon) - aarch64-darwin"
    @echo "  macOS (Intel)        - x86_64-darwin"
    @echo "  Linux (WSL2)         - x86_64-linux"
    @echo ""
    @echo "Examples:"
    @echo "  just switch    # Build and switch"
    @echo "  just restore ../nixos-config-backup-20231201-143022"

# Generate Brewfile from casks.nix
brewfile:
    @echo "🍺 Generating Brewfile from casks.nix..."
    ./scripts/generate-brewfile.sh

# Setup git hooks for automatic Brewfile generation
setup-hooks:
    @echo "🔧 Setting up git hooks..."
    ./scripts/setup-git-hooks.sh 

# Install apps from Brewfile in ~/.config/Brewfile
brew-install:
    @echo "🍻 Installing apps from ~/.config/Brewfile..."
    @if [ -f ~/.config/Brewfile ]; then \
        cd ~/.config && brew bundle install; \
    else \
        echo "❌ No Brewfile found at ~/.config/Brewfile"; \
        echo "💡 Copy your Brewfile there first: cp modules/shared/config/Brewfile ~/.config/"; \
        exit 1; \
    fi 
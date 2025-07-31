# Justfile for NixOS Configuration Management
# Run 'just --list' to see all available commands

# Default target - show help
default:
    @just --list

# Helper function to get correct system name
get_system:
    #!/usr/bin/env bash
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if [[ "$(uname -m)" == "arm64" ]]; then
            echo "aarch64-darwin"
        elif [[ "$(uname -m)" == "x86_64" ]]; then
            echo "x86_64-darwin"
        else
            echo "Unknown Darwin architecture: $(uname -m)"
            exit 1
        fi
    elif [[ "$(uname -s)" == "Linux" ]]; then
        if [[ "$(uname -m)" == "x86_64" ]]; then
            echo "x86_64-linux"
        else
            echo "Unknown Linux architecture: $(uname -m)"
            exit 1
        fi
    else
        echo "Unsupported operating system: $(uname -s)"
        exit 1
    fi

# Build the configuration for the current system
build:
    #!/usr/bin/env bash
    echo "Building NixOS configuration..."
    SYSTEM=$(just get_system)
    nix run .#build

# Build and switch to the new configuration
switch:
    #!/usr/bin/env bash
    echo "Building and switching to new configuration..."
    SYSTEM=$(just get_system)
    nix run .#build-switch

# Apply configuration (runs the apply script)
apply:
    #!/usr/bin/env bash
    echo "Applying configuration..."
    SYSTEM=$(just get_system)
    nix run .#apply

# Rollback to previous configuration
rollback:
    #!/usr/bin/env bash
    echo "Rolling back to previous configuration..."
    SYSTEM=$(just get_system)
    nix run .#rollback

# Check system configuration
check:
    #!/usr/bin/env bash
    echo "Checking system configuration..."
    nix flake check

# Update flake inputs
update:
    #!/usr/bin/env bash
    echo "Updating flake inputs..."
    nix flake update

# Show current system info
info:
    #!/usr/bin/env bash
    echo "System Information:"
    echo "Architecture: $(uname -m)"
    echo "OS: $(uname -s)"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Nix System: $(just get_system)"

# Clean build artifacts
clean:
    #!/usr/bin/env bash
    echo "Cleaning build artifacts..."
    rm -rf result
    nix store gc

# Show flake dependencies
deps:
    #!/usr/bin/env bash
    echo "Flake dependencies:"
    nix flake show

# Enter development shell
dev:
    #!/usr/bin/env bash
    echo "Entering development shell..."
    nix develop



# Format Nix files
fmt:
    #!/usr/bin/env bash
    echo "Formatting Nix files..."
    nixpkgs-fmt **/*.nix

# Show configuration diff
diff:
    #!/usr/bin/env bash
    echo "Showing configuration diff..."
    SYSTEM=$(just get_system)
    if [[ "$SYSTEM" == *"darwin"* ]]; then
        nix build .#darwinConfigurations.$SYSTEM.system --dry-run
    elif [[ "$SYSTEM" == *"linux"* ]]; then
        nix build .#nixosConfigurations.$SYSTEM.config.system.build.toplevel --dry-run
    fi

# Backup current configuration
backup:
    #!/usr/bin/env bash
    echo "Creating backup..."
    cp -r . ../nixos-config-backup-$(date +%Y%m%d-%H%M%S)

# Restore from backup (requires backup path)
restore backup_path:
    #!/usr/bin/env bash
    echo "Restoring from backup: {{backup_path}}"
    if [ -d "{{backup_path}}" ]; then
        cp -r {{backup_path}}/* .
        echo "Restore completed"
    else
        echo "Backup path not found: {{backup_path}}"
        exit 1
    fi

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
    @echo "Supported Systems:"
    @echo "  macOS (Apple Silicon) - aarch64-darwin"
    @echo "  macOS (Intel)        - x86_64-darwin"
    @echo ""
    @echo "Examples:"
    @echo "  just switch    # Build and switch"
    @echo "  just restore ../nixos-config-backup-20231201-143022" 
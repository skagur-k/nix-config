# Nix Overlays

This directory contains Nix overlays that are automatically applied during each build. Overlays allow you to modify, patch, or extend packages without forking the entire nixpkgs repository.

## Overview

Overlays provide a way to:
- **Apply patches** to existing packages
- **Override package versions** with specific commits or forks
- **Add custom packages** not available in nixpkgs
- **Create workarounds** for temporary issues
- **Extend functionality** of existing packages

## 🎯 Common Use Cases

### Package Patching
```nix
# Example: Apply a patch to fix a bug
final: prev: {
  package-name = prev.package-name.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [
      ./patches/fix-bug.patch
    ];
  });
}
```

### Version Overrides
```nix
# Example: Use a specific version or fork
final: prev: {
  package-name = prev.package-name.override {
    version = "1.2.3";
    src = prev.fetchFromGitHub {
      owner = "username";
      repo = "package-name";
      rev = "specific-commit";
      sha256 = "...";
    };
  };
}
```

### Custom Packages
```nix
# Example: Add a custom package
final: prev: {
  my-custom-tool = prev.stdenv.mkDerivation {
    pname = "my-custom-tool";
    version = "1.0.0";
    src = ./src/my-custom-tool;
    # ... build configuration
  };
}
```

## 📁 Layout

```
.
├── README.md          # This file
├── default.nix        # Main overlay that imports all others
└── [other-overlays]   # Individual overlay files
```

## 🔧 Usage

### Automatic Loading
Overlays in this directory are automatically loaded by the main configuration. No additional setup required.

### Adding New Overlays

1. **Create overlay file**: Create a new `.nix` file in this directory
2. **Define overlay function**: Use the `final: prev:` pattern
3. **Import in default.nix**: Add to the main overlay file
4. **Rebuild**: Changes are automatically applied on next build

### Example Overlay Structure

```nix
# my-overlay.nix
final: prev: {
  # Your overlay modifications here
  custom-package = prev.stdenv.mkDerivation {
    # Package definition
  };
}
```

```nix
# default.nix
self: super: {
  # Import other overlays
  my-overlay = import ./my-overlay.nix;
}
```

## 🚀 Best Practices

### Naming Conventions
- Use descriptive names for overlay files
- Prefix with purpose (e.g., `patch-`, `custom-`, `workaround-`)
- Keep overlays focused on a single purpose

### Version Management
- Document why overlays are needed
- Include links to issues or discussions
- Plan for removal when upstream fixes are available

### Testing
- Test overlays thoroughly before committing
- Ensure they don't break other packages
- Consider impact on build times

## 🔄 Workflow

### Creating a New Overlay

1. **Identify the need**: Determine what package needs modification
2. **Create overlay file**: Add new `.nix` file to this directory
3. **Implement changes**: Write the overlay function
4. **Test locally**: Build and test the modified package
5. **Commit changes**: Add to version control with clear documentation

### Maintaining Overlays

1. **Regular review**: Check if overlays are still needed
2. **Update patches**: Keep patches current with upstream changes
3. **Remove obsolete overlays**: Clean up when no longer needed
4. **Document changes**: Keep README updated with current overlays

## 🔗 Resources

- [Nix Overlays Documentation](https://nixos.org/manual/nixpkgs/stable/#chap-overlays)
- [nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)
- [NixOS Wiki - Overlays](https://nixos.wiki/wiki/Overlays)

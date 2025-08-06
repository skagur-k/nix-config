{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "skagur";
  name = "Nam Hyuck (James) Kim";
  email = "namhyuck.kim@one-line.com";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # Import the shared module
  imports = [
    
  ];

  # This is a pure Home Manager configuration for work MacBooks
  # No system-level configuration - everything runs in user space

  # Allow unfree packages (this will merge with shared settings)
  nixpkgs.config.allowUnfree = true;

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";

    # Work-specific packages (will be added to shared packages)
    packages = pkgs.callPackage ./packages.nix { };

    # Merge shared files with work-specific files
    file = lib.mkMerge [
      sharedFiles
      additionalFiles
    ];
  };

  programs = {
# SSH configuration
    ssh = {
      enable = true;
      addKeysToAgent = "yes";

      # SSH host configurations
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          useKeychain = true;
          identitiesOnly = true;
        };

        # Default key configuration
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_otsk";
        };

        # Personal GitHub configuration using personal key
        "github-personal" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
    # Work-specific git configuration (extends shared git config)
    git = {
      userName = name;
      userEmail = email;
      extraConfig = {};

        # Add any work-specific git settings here
        # user = {
        #   name = "Your Work Name";
        #   email = "your.work@company.com";
        # };
      };
    };

    # Work-specific shell aliases (extends shared zsh config)
    zsh = {
      shellAliases = {
        # Add work-specific aliases here
        # work-deploy = "kubectl apply -f .";
        # work-logs = "kubectl logs -f";
      };

      
    };

    # Enable programs that don't require system-level changes
    home-manager.enable = true;

    
  }
}

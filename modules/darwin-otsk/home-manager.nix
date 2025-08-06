{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "skagur";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # Import the shared module
  imports = [
    ../shared/home-manager.nix
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

  # Work-specific git configuration (extends shared git config)
  programs.git = {
    extraConfig = {
      # Add any work-specific git settings here
      # user = {
      #   name = "Your Work Name";
      #   email = "your.work@company.com";
      # };
    };
  };

  # Work-specific shell aliases (extends shared zsh config)
  programs.zsh = {
    shellAliases = {
      # Add work-specific aliases here
      # work-deploy = "kubectl apply -f .";
      # work-logs = "kubectl logs -f";
    };
  };

  # Enable programs that don't require system-level changes
  programs.home-manager.enable = true;
}

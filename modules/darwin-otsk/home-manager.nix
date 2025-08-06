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
  # This is a pure Home Manager configuration for work MacBooks
  # No system-level configuration - everything runs in user space

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";

    # Work-specific packages
    packages = pkgs.callPackage ./packages.nix { };

    # Work-specific configuration files
    file = additionalFiles;
  };

  # Programs configuration is inherited from shared/home-manager.nix
  # You can override or extend any program configurations here if needed

  # Example of work-specific git configuration
  programs.git = {
    extraConfig = {
      # Add any work-specific git settings here
      # user = {
      #   name = "Your Work Name";
      #   email = "your.work@company.com";
      # };
    };
  };

  # Work-specific shell aliases
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

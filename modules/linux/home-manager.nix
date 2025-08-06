{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "skagur";
  # sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
    ../shared/home-manager.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "25.05";
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { };
    file = lib.mkMerge [
      # sharedFiles
      additionalFiles
    ];

    # WSL2 specific environment variables
    sessionVariables = {
      WSLENV = "1";
    };
  };

  programs = {
    # SSH configuration
    ssh = {
      enable = true;
      addKeysToAgent = "yes";

      # SSH host configurations
      matchBlocks = {
        # Default key configuration
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_otsk";
        };
        "github-personal.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };

}

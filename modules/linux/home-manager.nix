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
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { };
    file = lib.mkMerge [
      sharedFiles
      additionalFiles
    ];
  };

  programs = { } // import ../shared/home-manager.nix { inherit config pkgs lib; };

  # WSL2 specific environment variables
  home.sessionVariables = {
    WSLENV = "1";
  };
}

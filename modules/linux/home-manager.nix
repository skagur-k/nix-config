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
  imports = [
    ../shared/default.nix
    ../shared/home-manager.nix
  ];

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
    
    # WSL2 specific environment variables
    sessionVariables = {
      WSLENV = "1";
    };
  };
}

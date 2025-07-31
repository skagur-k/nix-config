{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}:

let
  user = "skagur";

  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix { };
    file = lib.mkMerge [
      sharedFiles
      additionalFiles
    ];
    stateVersion = "23.11";
  };

  programs = { } // import ../shared/home-manager.nix { inherit config pkgs lib; };

  # WSL2 specific environment variables
  home.sessionVariables = {
    WSLENV = "1";
    DISPLAY = ":0";
  };
}

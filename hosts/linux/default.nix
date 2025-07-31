{ config, pkgs, ... }:

let
  user = "skagur";
in
{
  imports = [
    ../../modules/linux/home-manager.nix
  ];

  # Home-manager configuration for Linux
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    verbose = false;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ../../modules/linux/packages.nix { };
        file = lib.mkMerge [
          (import ../../modules/shared/files.nix { inherit config pkgs; })
          (import ../../modules/linux/files.nix { inherit config pkgs; })
        ];
        stateVersion = "24.05";
      };
      programs = { } // import ../../modules/shared/home-manager.nix { inherit config pkgs lib; };
    };
  };
} 
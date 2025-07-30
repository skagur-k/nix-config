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

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    verbose = false;
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
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
      };
  };

  # WSL2 specific environment variables
  environment.sessionVariables = {
    WSLENV = "1";
    DISPLAY = ":0";
  };
}

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

  # User configuration without sudo requirements
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # No homebrew configuration since we don't have sudo access
  # All applications will need to be installed manually or via alternative methods

  # Enable home-manager for user-space configuration only
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
          stateVersion = "25.05";
        };
        programs = (import ../shared/home-manager.nix { inherit config pkgs lib; }).programs;
      };
  };
}

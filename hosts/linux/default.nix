{ config, pkgs, ... }:

let
  user = "skagur";
in
{
  imports = [
    ../../modules/linux/home-manager.nix
  ];

  # SOPS configuration for secrets management
  sops = {
    defaultSopsFile = ../../secrets/id_ed25519.enc;
    age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";

    secrets = {
      "id_ed25519" = {
        path = "/Users/${user}/.ssh/id_ed25519";
        mode = "0600";
        owner = user;
      };
    };
  };
  # Home-manager configuration for Linux
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
          packages = pkgs.callPackage ../../modules/linux/packages.nix { };
          file = lib.mkMerge [
            (import ../../modules/shared/files.nix { inherit config pkgs; })
            (import ../../modules/linux/files.nix { inherit config pkgs; })
          ];
          stateVersion = "25.05";
        };
        programs = { } // import ../../modules/shared/home-manager.nix { inherit config pkgs lib; };
      };
  };
}

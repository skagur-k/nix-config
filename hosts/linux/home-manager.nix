{ config, pkgs, lib, ... }:

let
  user = "skagur";
in
{
  imports = [
    ../../modules/linux/home-manager.nix
  ];

  # SOPS configuration
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    secrets = {
      "id_ed25519" = {
        path = "/home/${user}/.ssh/id_ed25519";
        mode = "0600";
      };
      "id_ed25519.pub" = {
        path = "/home/${user}/.ssh/id_ed25519.pub";
        mode = "0600";
      };
      "id_ed25519_otsk" = {
        path = "/home/${user}/.ssh/id_ed25519_otsk";
        mode = "0600";
      };
      "id_ed25519_otsk.pub" = {
        path = "/home/${user}/.ssh/id_ed25519_otsk.pub";
        mode = "0600";
      };
    };
  };
}

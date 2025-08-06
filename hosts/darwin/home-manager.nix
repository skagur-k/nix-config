{ config, pkgs, lib, ... }:

let
  user = "skagur";
in
{
  imports = [
    ../../modules/darwin/home-manager.nix
  ];

  # SOPS configuration for Darwin
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";

    secrets = {
      "id_ed25519" = {
        path = "/Users/${user}/.ssh/id_ed25519";
        mode = "0600";
      };
      "id_ed25519.pub" = {
        path = "/Users/${user}/.ssh/id_ed25519.pub";
        mode = "0600";
      };
    };
  };
}

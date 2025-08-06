{ config, pkgs, ... }:

let
  user = "skagur";
in

{
  imports = [
    ../../modules/darwin-otsk/home-manager.nix
    ../../modules/shared
  ];

  # SOPS configuration for secrets management
  sops = {
    age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";

    secrets = {
      "id_ed25519_otsk" = {
        sopsFile = ../../secrets/id_ed25519_otsk.enc;
        path = "/Users/${user}/.ssh/id_ed25519_otsk";
        mode = "0600";
        owner = user;
      };
      "id_ed25519_personal" = {
        sopsFile = ../../secrets/id_ed25519.enc;
        path = "/Users/${user}/.ssh/id_ed25519";
        mode = "0600";
        owner = user;
      };
    };
  };

  # Set the hostname for work MacBook
  networking.hostName = "skagur-otsk";

  # Disable nix-darwin's Nix management since we don't have sudo
  nix = {
    enable = false;
    package = pkgs.nix;

    settings = {
      # User-level settings that don't require sudo
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Only include packages, no system packages since we don't have sudo
  environment.systemPackages = [
    # Minimal system packages that don't require special permissions
  ]
  ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    # No system defaults since we don't have sudo access
    # All system preferences will need to be set manually
  };
}

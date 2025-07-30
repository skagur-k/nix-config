{ config, pkgs, ... }:

let
  user = "skagur";
in

{
  imports = [
    ../../modules/wsl2-ubuntu/home-manager.nix
    ../../modules/shared
  ];

  nix = {
    settings = {
      trusted-users = [ "${user}" ];
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

  environment.systemPackages =
    with pkgs;
    [
    ]
    ++ (import ../../modules/shared/packages.nix { inherit pkgs; })
    ++ (import ../../modules/wsl2-ubuntu/system-packages.nix { inherit pkgs; });

  system = {
    stateVersion = "23.11";
  };

  # Basic system configuration
  time.timeZone = "UTC";

  # Internationalisation
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sound
  sound.enable = true;

  # Define user account
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable services
  services = {
    # SSH server
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # Printing
    printing.enable = true;

    # Bluetooth
    blueman.enable = true;
  };

  # Security
  security = {
    sudo.wheelNeedsPassword = false;
    auditd.enable = true;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };

  # Boot
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}

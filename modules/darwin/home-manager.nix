{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}:

let
  user = "skagur";
  additionalFiles = import ./files.nix { inherit user config pkgs; };
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
in
{
  imports = [

  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      # "wireguard" = 1451685025;
    };
  };

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
          username = user;
          homeDirectory = "/Users/${user}";
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            additionalFiles
            sharedFiles
          ];
          stateVersion = "25.05";
        };

        programs = (import ../shared/home-manager.nix { inherit config pkgs lib; }).programs // {
          # SSH configuration

          ssh = {
            enable = true;
            addKeysToAgent = "yes";

            # SSH host configurations
            matchBlocks = {
              # Default key configuration
              "github.com" = {
                hostname = "github.com";
                user = "git";
                identityFile = "~/.ssh/id_ed25519";
              };
            };
          };
        };
      };
  };

}

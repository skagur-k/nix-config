{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/shared/home-manager.nix
    ../../modules/wsl2-ubuntu/home-manager.nix
  ];

  home = {
    stateVersion = "23.11";
  };

  # WSL2 specific environment variables
  home.sessionVariables = {
    WSLENV = "1";
    DISPLAY = ":0";
  };
}

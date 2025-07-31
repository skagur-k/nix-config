{
  config,
  pkgs,
  lib,
  ...
}:

{
  # WSL2 specific environment variables
  home.sessionVariables = {
    WSLENV = "1";
  };
}

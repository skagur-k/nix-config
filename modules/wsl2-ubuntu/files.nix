{
  user,
  config,
  pkgs,
  ...
}:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
in
{
  # WSL2 configuration
  "/etc/wsl.conf" = {
    text = ''
      [boot]
      systemd=true

      [automount]
      enabled = true
      root = /mnt/
      options = "metadata,umask=22,fmask=11"
      mountFsTab = false

      [network]
      generateHosts = true
      generateResolvConf = true
    '';
  };

  # WSL2 specific environment variables
  "${xdg_configHome}/wsl/environment" = {
    text = ''
      # WSL2 specific environment variables
      export WSLENV=1
      export DISPLAY=:0
    '';
  };
}

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
  # Ghostty configuration
  "${xdg_configHome}/ghostty/config" = {
    text = builtins.readFile ./config/ghostty/config;
  };

  # LeaderKey configuration
  "${xdg_configHome}/leaderkey/config.json" = {
    text = builtins.readFile ./config/leaderkey/config.json;
  };
}

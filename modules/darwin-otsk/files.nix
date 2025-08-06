{
  user,
  config,
  pkgs,
}:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
in
{
  # Work-specific configuration files
  # Add any work-specific dotfiles or configuration here

  # Example: Work-specific git configuration
  # "${xdg_configHome}/git/config-work".text = ''
  #   [user]
  #     name = "Your Work Name"
  #     email = "your.work@company.com"
  # '';

  # Work-specific shell aliases or functions can be added here
  # "${xdg_configHome}/work/aliases.sh".text = ''
  #   # Work-specific aliases
  #   alias work-deploy="kubectl apply -f ."
  #   alias work-logs="kubectl logs -f"
  # '';
}

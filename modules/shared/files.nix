{ pkgs, config, ... }:

{
  # Starship configuration
  ".config/starship.toml" = {
    text = builtins.readFile ./config/starship/starship.toml;
  };

  # Zsh aliases
  ".config/zsh/aliases.zsh" = {
    text = builtins.readFile ./config/zsh/aliases.zsh;
  };

  # Zsh functions
  ".config/zsh/functions.zsh" = {
    text = builtins.readFile ./config/zsh/functions.zsh;
  };

  # Zsh keybindings
  ".config/zsh/keybindings.zsh" = {
    text = builtins.readFile ./config/zsh/keybindings.zsh;
  };

  # Zellij configuration
  ".config/zellij/config.kdl" = {
    text = builtins.readFile ./config/zellij/zellij.kdl;
  };

  # Helix configuration
  ".config/helix/config.toml" = {
    text = builtins.readFile ./config/helix/config.toml;
  };
}

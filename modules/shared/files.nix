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

  # Zsh env
  ".config/zsh/env.zsh" = {
    text = builtins.readFile ./config/zsh/env.zsh;
  };

  # Zellij configuration
  ".config/zellij/config.kdl" = {
    text = builtins.readFile ./config/zellij/zellij.kdl;
  };

  # Helix configuration
  ".config/helix/config.toml" = {
    text = builtins.readFile ./config/helix/config.toml;
  };

  # k9S (config.yaml) configuration
  ".config/k9s/config.yaml" = {
    text = builtins.readFile ./config/k9s/config.yaml;
  };

  # k9s (alias.yaml) configuration
  ".config/k9s/aliases.yaml" = {
    text = builtins.readFile ./config/k9s/aliases.yaml;
  };

  # k9s (transparent.yaml) configuration
  ".config/k9s/skins/transparent.yaml" = {
    text = builtins.readFile ./config/k9s/skins/transparent.yaml;
  };

  # Brewfile
  ".config/Brewfile" = {
    text = builtins.readFile ./config/Brewfile;
  };
}

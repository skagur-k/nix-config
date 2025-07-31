{ config, pkgs, ... }:

let
  user = "skagur";
  homeDirectory = "/home/${user}";
  configHome = "${homeDirectory}/.config";
  xdgConfigHome = configHome;
in
{
  # Deploy shared configuration files
  "${configHome}/zsh/.zshrc" = {
    source = ./config/zsh/.zshrc;
  };

  "${configHome}/zsh/env.zsh" = {
    source = ../shared/config/zsh/env.zsh;
  };

  "${configHome}/zsh/aliases.zsh" = {
    source = ../shared/config/zsh/aliases.zsh;
  };

  "${configHome}/zsh/functions.zsh" = {
    source = ../shared/config/zsh/functions.zsh;
  };

  "${configHome}/zsh/keybindings.zsh" = {
    source = ../shared/config/zsh/keybindings.zsh;
  };

  "${configHome}/helix/config.toml" = {
    source = ../shared/config/helix/config.toml;
  };

  "${configHome}/starship/starship.toml" = {
    source = ../shared/config/starship/starship.toml;
  };

  "${configHome}/zellij/config.kdl" = {
    source = ../shared/config/zellij/zellij.kdl;
  };
} 
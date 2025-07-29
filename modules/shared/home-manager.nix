{
  config,
  pkgs,
  lib,
  ...
}:

let
  name = "Namhyuck (James) Kim";
  user = "skagur";
  email = "namhyuck.james@gmail.com";
in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = false;

    # Custom zsh configuration
    initContent = ''
      # Load Nix environment
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Source zsh configuration files
      if [[ -f ~/.config/zsh/aliases.zsh ]]; then
          source ~/.config/zsh/aliases.zsh
      fi

      if [[ -f ~/.config/zsh/functions.zsh ]]; then
          source ~/.config/zsh/functions.zsh
      fi

      # History configuration
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history

      # Better history searching
      bindkey '^R' history-incremental-search-backward
      bindkey '^ ' autosuggest-accept

      # Set editor
      export EDITOR=helix
      export VISUAL=helix

      eval "$(zellij setup --generate-auto-start zsh)"
    '';
  };

  # Zoxide configuration
  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # FZF configuration
  fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "eza --all --color=always";
    defaultOptions = [
      "--height 40%"
      "--border"
    ];
    fileWidgetCommand = "eza --all --color=always";
    fileWidgetOptions = [
      "--height 40%"
      "--border"
    ];
    historyWidgetOptions = [
      "--height 40%"
      "--border"
    ];
  };

  starship = {
    enable = true;
    enableZshIntegration = true;
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "helix";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

}

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
    initContent = builtins.readFile ./config/zsh/.zshrc;
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

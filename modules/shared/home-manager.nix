{
  config,
  pkgs,
  lib,
  ...
}:

let
  name = "Nam Hyuck (James) Kim";
  user = "skagur";
  email = "namhyuck.james@gmail.com";
in
{
  programs = {
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

    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--git"
        "--git-repos"
        "-o"
        "--header"
        "--hyperlink"
      ];
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

    atuin = {
      enable = true;
      settings = {
        enter_accept = false;
        inline_height = 10;
      };
    };

    kubecolor = {
      enable = true;
      enableZshIntegration = true;
      enableAlias = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
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
          editor = "hx";
          autocrlf = "input";
          pager = "delta";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = true;
          dark = true;
          side-by-side = true;
        };
        merge = {
          conflictstyle = "zdiff3";
        };
        url = {
          "https://github.com/skagur-k/" = {
            insteadOf = "skagur:";
          };
          "https://github.com/ocean-network-express/" = {
            insteadOf = "one:";
          };
        };
        push = {
          autoSetupRemote = true;
          default = "current";
        };
        pull = {
          default = "current";
          rebase = true;
        };
        rebase.autoStash = true;
      };

    };

  };
}

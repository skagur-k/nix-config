{ pkgs }:

with pkgs;
[
  # General packages for development and system management
  bat
  btop
  coreutils
  killall
  openssh
  wget
  zip
  zoxide
  just
  du-dust
  dua

  # Text and terminal utilities
  eza
  fzf
  helix
  htop
  jq
  ripgrep
  starship
  tree
  unrar
  unzip
  zellij
  difftastic
  fd
  skim

  # Python packages
  python3
  virtualenv

  # Development Packages
  kubectl
  kubectx
  gh
  terraform

]

{ pkgs }:

with pkgs;
[
  # Essential development tools
  gcc
  gnumake
  cmake
  pkg-config
  python3
  nodejs
  yarn

  # Basic utilities
  git
  curl
  wget
  htop
  tree
  ripgrep
  fd
  bat
  exa
  fzf
  tmux

  # Container tools
  docker
  docker-compose
]

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
  fastfetch

  # Text and terminal utilities
  helix
  htop
  jq
  yq
  ripgrep
  tree
  unzip
  zellij
  fd
  skim
  delta

  # Development Packages
  kubectl
  kubectx
  gh
  google-cloud-sdk
  k9s
  lazygit
  pre-commit

  # Nix development tools
  nixpkgs-fmt

  # Secret Management tools
  sops
  age
]

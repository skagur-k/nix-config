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
  helix
  htop
  jq
  ripgrep
  tree
  unrar
  unzip
  zellij
  fd
  skim
  delta

  # Python packages
  python3
  virtualenv

  # Development Packages
  kubectl
  kubectx
  gh
  terraform
  google-cloud-sdk
  k9s

  # Nix development tools
  nixpkgs-fmt
]

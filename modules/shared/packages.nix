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
  eza
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

  # Python packages
  python3
  virtualenv

  # Development Packages
  kubectl
  kubectx
  gh
  tenv
  cosign
  google-cloud-sdk
  k9s
  lazygit
  pre-commit
  nodejs_22

  # Nix development tools
  nixpkgs-fmt

  # Secret Management tools
  sops
  age
]

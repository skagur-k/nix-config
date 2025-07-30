{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  # WSL2 specific tools
  wslu
  wslview

  # Additional development tools
  rustc
  cargo
  go
  deno

  # Additional utilities
  tldr
  cheat
  navi
  zoxide
  starship
]

{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  # Linux-specific packages
  # Add any Linux-specific packages here if needed
] 
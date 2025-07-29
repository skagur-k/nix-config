{ pkgs, config, ... }:

{
  # Starship configuration
  ".config/starship.toml" = {
    text = builtins.readFile ./config/starship.toml;
  };
}

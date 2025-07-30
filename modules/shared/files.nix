{ pkgs, config, ... }:

let
  # Function to recursively find all files in a directory
  findFiles =
    dir:
    let
      entries = builtins.readDir dir;
      files = builtins.attrNames (builtins.filterAttrs (name: type: type == "regular") entries);
      dirs = builtins.attrNames (builtins.filterAttrs (name: type: type == "directory") entries);

      # Direct files in this directory
      directFiles = builtins.listToAttrs (
        builtins.map (file: {
          name = file;
          value = "${dir}/${file}";
        }) files
      );

      # Recursively find files in subdirectories
      subdirFiles = builtins.foldl' (
        acc: subdir:
        acc // (builtins.mapAttrs (name: path: "${dir}/${subdir}/${name}") (findFiles "${dir}/${subdir}"))
      ) { } dirs;
    in
    directFiles // subdirFiles;

  # Get all files in the config directory
  configFiles = findFiles ./config;

  # Function to convert file path to home-manager path
  toHomeManagerPath =
    filePath:
    let
      # Remove ./config/ prefix and convert to home-manager format
      relativePath = builtins.substring 9 (builtins.stringLength filePath) filePath;
      fileName = builtins.baseNameOf relativePath;
      dirName = builtins.dirOf relativePath;

      # Handle special cases for different file types
      homeManagerPath =
        if fileName == ".zshrc" then
          ".zshrc"
        else if dirName == "zsh" then
          ".config/zsh/${fileName}"
        else if dirName == "helix" then
          ".config/helix/${fileName}"
        else if dirName == "zellij" then
          ".config/zellij/config.kdl" # Zellij expects config.kdl
        else if dirName == "starship" then
          ".config/starship.toml"
        else
          ".config/${relativePath}";
    in
    homeManagerPath;

in
# Generate home-manager file entries automatically
builtins.listToAttrs (
  builtins.map (filePath: {
    name = toHomeManagerPath filePath;
    value = {
      text = builtins.readFile filePath;
    };
  }) (builtins.attrValues configFiles)
)

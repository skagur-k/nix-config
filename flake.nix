{
  description = "Starter Configuration for MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      home-manager,
      nixpkgs,
      sops-nix,
    }@inputs:
    let
      user = "skagur";
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      linuxSystems = [
        "x86_64-linux"
      ];
      allSystems = darwinSystems ++ linuxSystems;
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems f;
      devShell =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default =
            with pkgs;
            mkShell {
              nativeBuildInputs = with pkgs; [
                bashInteractive
                git
              ];
              shellHook = with pkgs; ''
                export EDITOR=vim
              '';
            };
        };
      mkApp = scriptName: system: {
        type = "app";
        program = "${
          (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
            #!/usr/bin/env bash
            PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
            echo "Running ${scriptName} for ${system}"
            exec ${self}/apps/${system}/${scriptName}
          '')
        }/bin/${scriptName}";
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
        # Work MacBook apps (no sudo required)
        "apply-otsk" = mkApp "apply-otsk" system;
        "build-otsk" = mkApp "build-otsk" system;
        "build-switch-otsk" = mkApp "build-switch-otsk" system;
        "rollback-otsk" = mkApp "rollback-otsk" system;
      };

      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      apps =
        nixpkgs.lib.genAttrs darwinSystems mkDarwinApps // nixpkgs.lib.genAttrs linuxSystems mkLinuxApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (
        system:
        let
          user = "skagur";
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            sops-nix.darwinModules.sops
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/skagur-mba
          ];
        }
      );

      # Configuration for Linux
      homeConfigurations = {
        wsl2 = nixpkgs.lib.genAttrs linuxSystems (
          system:
          let
            user = "skagur";
          in
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              sops-nix.homeManagerModules.sops
              ./hosts/wsl2
            ];
          }
        );

        # Work MacBook Home Manager configuration (no sudo required)
        # skagur-work =
        #   let
        #     system = "aarch64-darwin";
        #     user = "skagur";
        #   in
        #   home-manager.lib.homeManagerConfiguration {
        #     pkgs = nixpkgs.legacyPackages.${system};
        #     modules = [
        #       sops-nix.homeManagerModules.sops
        #       ./hosts/linux
        #     ];
        #   };
      };
    };
}

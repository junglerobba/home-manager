{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms = {
      url = "github:jrmoulton/tmux-sessionizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpak-builder-tools = {
      url = "github:flatpak/flatpak-builder-tools";
      flake = false;
    };
  };

  outputs =
    { home-manager, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays =
            (import ./overlays.nix {
              flatpak-builder-tools = inputs.flatpak-builder-tools;
            })
            ++ [
              inputs.nixgl.overlays.default
              inputs.tms.overlays.default
              inputs.helix.overlays.default
            ];
        };

        extraSpecialArgs =
          {
            username,
            homedir,
            isNixOs,
            desktop,
          }:
          let
            isLinux = pkgs.stdenv.hostPlatform.isLinux;
            isMac = pkgs.stdenv.hostPlatform.isDarwin;
          in
          {
            inherit
              pkgs
              username
              homedir
              isNixOs
              isLinux
              isMac
              desktop
              ;
            nixGL = import ./nixgl.nix {
              inherit pkgs;
              config = {
                nixGLPrefix =
                  if isLinux && !isNixOs then
                    with pkgs; "${nixgl.nixGLIntel}/bin/nixGLIntel ${nixgl.nixVulkanIntel}/bin/nixVulkanIntel"
                  else
                    "";
              };
            };
          };
      in
      {
        defaultPackage =
          {
            username,
            homedir,
            desktop ? null,
          }:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = extraSpecialArgs {
              inherit username homedir desktop;
              isNixOs = false;
            };
            modules = [ ./home.nix ];
          };

        packages.module =
          {
            username,
            homedir,
            desktop,
          }:
          {
            users.${username} = import ./home.nix;
            extraSpecialArgs = extraSpecialArgs {
              inherit username homedir desktop;
              isNixOs = true;
            };
          };
      }
    );
}

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
    coffee-break = {
      url = "github:junglerobba/coffee-break";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { home-manager, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        mpv-overlay = (
          self: super: {
            mpv =
              if self.stdenv.hostPlatform.isLinux then
                super.mpv.override { scripts = [ self.mpvScripts.mpris ]; }
              else
                super.mpv;
          }
        );
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            mpv-overlay
            inputs.nixgl.overlays.default
            inputs.tms.overlays.default
            inputs.helix.overlays.default
            inputs.coffee-break.overlays.default
          ];
        };
        extraSpecialArgs =
          {
            username,
            homedir,
            isNixOs,
            desktop,
          }:
          {
            inherit
              username
              homedir
              isNixOs
              desktop
              system
              ;
            isMac = pkgs.stdenv.hostPlatform.isDarwin;
            isLinux = pkgs.stdenv.hostPlatform.isLinux;
            nixGL = import ./nixgl.nix {
              inherit pkgs;
              config = {
                nixGLPrefix =
                  with pkgs;
                  if !isNixOs then
                    "${nixgl.nixGLIntel}/bin/nixGLIntel ${nixgl.nixVulkanIntel}/bin/nixVulkanIntel"
                  else
                    "";
              };
            };
          };
      in
      {
        defaultPackage =
          { username, homedir }:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = extraSpecialArgs {
              inherit username homedir;
              isNixOs = false;
              desktop = null;
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

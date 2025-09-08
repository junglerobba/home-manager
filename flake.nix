{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms.url = "github:jrmoulton/tmux-sessionizer?ref=v0.5.0";
    coffee-break = {
      url = "github:junglerobba/coffee-break";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
    jj.url = "github:jj-vcs/jj?ref=v0.33.0";
  };

  outputs =
    { home-manager, nix-darwin, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgsConfig = {
          overlays = [
            inputs.nixgl.overlays.default
            inputs.tms.overlays.default
            inputs.helix.overlays.default
            inputs.jj.overlays.default
            inputs.coffee-break.overlays.default
          ]
          ++ (import ./overlays.nix);
        };
        pkgs = import inputs.nixpkgs (
          {
            inherit system;
          }
          // pkgsConfig
        );

        extraSpecialArgs =
          {
            username,
            homedir ? null,
            isNixOs ? false,
            desktop ? null,
            darwin ? false,
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
              darwin
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
        packages = {

          default =
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

          darwin =
            {
              modules ? [ ],
              username,
            }:
            let
              specialArgs = extraSpecialArgs {
                inherit username;
                desktop = null;
                homedir = "/Users/${username}";
                isNixOs = false;
                darwin = true;
              };
            in
            nix-darwin.lib.darwinSystem {
              inherit system;
              inherit specialArgs;
              modules = [
                ./darwin
                home-manager.darwinModules.home-manager
                {
                  users.users.${username} = {
                    name = username;
                    home = "/Users/${username}";
                  };
                  nixpkgs = pkgsConfig;
                  home-manager = {
                    extraSpecialArgs = specialArgs;
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.${username} = import ./home.nix;
                  };
                }
              ]
              ++ modules;
            };

          nixos =
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

        };
      }
    );
}

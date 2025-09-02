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
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms.url = "github:jrmoulton/tmux-sessionizer?ref=v0.5.0";
    coffee-break.url = "github:junglerobba/coffee-break";
    helix.url = "github:helix-editor/helix";
    jj.url = "github:jj-vcs/jj?ref=735a27d4efae6b5a0524f10fca23b0b1b61becc0";
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
            bootstrap ? false,
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
              bootstrap
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
              bootstrap ? false, # required on initial setup to have a linux builder
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
                inputs.nix-rosetta-builder.darwinModules.default
                {
                  nix-rosetta-builder = {
                    enable = !bootstrap;
                    onDemand = true;
                    onDemandLingerMinutes = 5;
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

{ pkgs, tms, ... }:
let
  packages = with pkgs; [
    dive
    fastfetch
    ffmpeg
    lm_sensors
    nil
    nvtop-amd
    onefetch
    ranger
    rust-analyzer
    tms.packages."x86_64-linux".default
    wl-clipboard
    yarn
    yt-dlp
  ];
  nodePackages = with pkgs.nodePackages; [
    prettier
    eslint
    typescript-language-server
    vscode-langservers-extracted
    bash-language-server
  ];
in {

  home.username = "junglerobba";
  home.homeDirectory = "/var/home/junglerobba";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.packages = packages ++ nodePackages;

  imports = [
    ./fish
    ./helix
    ./lazygit
    ./tmux
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      tree_view = true;
      hide_userland_threads = true;
      highlight_base_name = true;
    };
  };
}

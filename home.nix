{ pkgs, ... }:
let
  nodePackages = with pkgs.nodePackages; [
    prettier
    eslint
    typescript-language-server
  ];
in {

  home.username = "junglerobba";
  home.homeDirectory = "/var/home/junglerobba";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.packages = with pkgs;
    [
      dive
      ffmpeg
      lm_sensors
      neofetch
      nil
      nvtop-amd
      ranger
      tmux-sessionizer
      wl-clipboard
      yarn
      yt-dlp
    ] ++ nodePackages;

  imports = [
    ./fish
    ./helix
    ./tmux
    ./neovim
  ];

  programs.direnv = { enable = true; };
  programs.htop = {
    enable = true;
    settings = {
      tree_view = true;
      hide_userland_threads = true;
      highlight_base_name = true;
    };
  };
}

{ pkgs, tms, ... }:
let
  packages = with pkgs; [
    fastfetch
    ffmpeg
    onefetch
    ranger
    tms.packages."x86_64-linux".default
    wl-clipboard
    yt-dlp
  ];
in {

  home.username = "junglerobba";
  home.homeDirectory = "/var/home/junglerobba";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.packages = packages;

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

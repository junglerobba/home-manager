{ pkgs, ... }: {

  home.username = "junglerobba";
  home.homeDirectory = "/var/home/junglerobba";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    ffmpeg
    lm_sensors
    neofetch
    nvtop-amd
    ranger
    tmux-sessionizer
    wl-clipboard
    yarn
    yt-dlp
  ];

  imports = [
    ./fish
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

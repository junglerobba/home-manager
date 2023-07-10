{ pkgs, ... }: {

  home.username = "junglerobba";
  home.homeDirectory = "/var/home/junglerobba";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    ffmpeg
    lm_sensors
    neofetch
    ranger
    tmux-sessionizer
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

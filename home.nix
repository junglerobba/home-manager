{ pkgs, tms, username, homedir, system, isMac, isLinux, ... }:
let
  packages = with pkgs; [
    fastfetch
    ffmpeg
    jless
    jq
    just
    onefetch
    ranger
    tms.packages.${system}.default
    yt-dlp
  ];
  linuxPackages = with pkgs; [ wl-clipboard ];
  macPackages = with pkgs; [
    audacity
    colima
    docker
    docker-compose
    gimp
    gnupg
    keepassxc
  ];
in {

  home.username = username;
  home.homeDirectory = homedir + "/" + username;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = isLinux;

  home.packages = packages ++ (if isMac then macPackages else [ ])
    ++ (if isLinux then linuxPackages else [ ]);

  imports = [ ./fish ./helix ./lazygit ./tmux ./colima ./git ./mpv ];

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

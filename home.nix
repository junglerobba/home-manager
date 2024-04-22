{ pkgs, tms, username, homedir, system, isMac, isLinux, isNixOs, ... }:
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
  linuxPackages = with pkgs;
    [ wl-clipboard distrobox ] ++ (if isNixOs then [
      gnupg
      gnomeExtensions.night-theme-switcher
    ] else [
      nixgl.nixGLIntel
      nixgl.nixVulkanIntel
    ]);
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
  home.homeDirectory = homedir;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = isLinux;

  home.packages = packages ++ (if isMac then macPackages else [ ])
    ++ (if isLinux then linuxPackages else [ ]);

  imports = [
    ./alacritty
    ./colima
    ./fish
    ./git
    ./gnome
    ./helix
    ./htop
    ./keyring
    ./lazygit
    ./mangohud
    ./mpv
    ./tmux
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}

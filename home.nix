{
  pkgs,
  username,
  homedir,
  isMac,
  isLinux,
  isNixOs,
  desktop,
  ...
}:
let
  packages = with pkgs; [
    fastfetch
    ffmpeg
    jless
    jq
    just
    onefetch
    ranger
    tmux-sessionizer
    yt-dlp
  ];
  linuxPackages =
    with pkgs;
    [
      wl-clipboard
      distrobox
    ]
    ++ (
      if isNixOs then
        [ gnupg ]
      else
        [
          nixgl.nixGLIntel
          nixgl.nixVulkanIntel
        ]
    )
    ++ (if desktop == "gnome" then [ gnomeExtensions.night-theme-switcher ] else [ ]);
  macPackages = with pkgs; [
    audacity
    coffee-break
    colima
    docker
    docker-compose
    gimp
    gnupg
    iterm2
    keepassxc
  ];
in
{

  home.username = username;
  home.homeDirectory = homedir;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = isLinux;

  home.packages =
    packages ++ (if isMac then macPackages else [ ]) ++ (if isLinux then linuxPackages else [ ]);

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
    ./sway
    ./tmux
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}

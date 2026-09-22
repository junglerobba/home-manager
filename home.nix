{
  pkgs,
  lib,
  inputs,
  username,
  homedir,
  isMac,
  isLinux,
  isNixOs,
  desktop,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  packages =
    (with pkgs; [
      aerc
      alacritty
      dive
      docker-client
      fastfetch
      ffmpeg
      gh
      grype
      jless
      jq
      just
      lazydocker
      lazysql
      lf
      nh
      nix-output-monitor
      nix-tree
      nixfmt
      onefetch
      yt-dlp
    ])
    ++ [
      inputs.diffsoup.packages.${system}.default
      inputs.tms.packages.${system}.default
    ];
  gnomeExtensions = import ./gnome/extensions.nix { inherit pkgs desktop; };
  linuxPackages =
    with pkgs;
    [
      distrobox
      (pkgs.callPackage ./pkgs/flatpak-cargo-generator { })
      nerd-fonts.adwaita-mono
      wl-clipboard
    ]
    ++ (if isNixOs then [ gnupg ] else [ ])
    ++ gnomeExtensions;
  macPackages =
    (with pkgs; [
      aerospace
      gnupg
      maccy
      nerd-fonts.iosevka
      podman
      tree
      watch
    ])
    ++ [
      inputs.coffee-break.packages.${system}.default
    ];
in
{
  home.username = username;
  home.homeDirectory = homedir;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux = lib.mkIf (isLinux && !isNixOs) {
    enable = true;
    gpu = {
      enable = true;
    };
  };

  home.packages =
    packages ++ (if isMac then macPackages else [ ]) ++ (if isLinux then linuxPackages else [ ]);

  imports = [
    ./aerospace
    ./alacritty
    ./dark-mode-notify
    ./fish
    ./git
    ./gnome
    ./gpg
    ./helix
    ./htop
    ./jujutsu
    ./keyring
    ./maccy
    ./mangohud
    ./mpv
    ./neovim
    ./services
    ./sway
    ./tms
    ./tmux
  ];

  fonts.fontconfig.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.pointerCursor = lib.mkIf isNixOs {
    enable = true;
    name = "Adwaita";
    size = 24;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

}

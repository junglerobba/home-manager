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
    dive
    docker-client
    fastfetch
    ffmpeg
    jless
    jq
    just
    lazydocker
    lf
    nix-tree
    onefetch
    tmux-sessionizer
    yt-dlp
  ];
  gnomeExtensions = import ./gnome/extensions.nix { inherit pkgs desktop; };
  linuxPackages =
    with pkgs;
    [
      cliphist
      distrobox
      flatpak-cargo-generator
      wl-clipboard
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
    ++ gnomeExtensions;
  macPackages = with pkgs; [
    colima
    gimp
    gnupg
    podman
  ];
in
{
  home.username = username;
  home.homeDirectory = homedir;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = isLinux && !isNixOs;

  home.packages =
    packages ++ (if isMac then macPackages else [ ]) ++ (if isLinux then linuxPackages else [ ]);

  imports = [
    ./alacritty
    ./fish
    ./git
    ./gnome
    ./helix
    ./htop
    ./jujutsu
    ./keyring
    ./mangohud
    ./mpv
    ./sway
    ./tmux
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.pointerCursor = pkgs.lib.mkIf (desktop == "sway") {
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

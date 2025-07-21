{
  pkgs,
  lib,
  isMac,
  isNixOs,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    package = lib.mkIf (!isNixOs) pkgs.null;
    settings = {
      terminal.shell = lib.mkIf (!isMac) "${pkgs.fish}/bin/fish";
      window = {
        option_as_alt = lib.mkIf isMac "Both";
        padding = {
          x = 5;
          y = 5;
        };
        decorations = lib.mkIf isMac "Buttonless";
        blur = true;
        opacity = 0.8;
      };
      font = {
        normal = {
          family = "adwaita mono";
        };
        size = 10.6;
        offset.y = 3;
      };
      general.import = [
        "~/.config/alacritty/theme.toml"
      ];
    };
  };
}

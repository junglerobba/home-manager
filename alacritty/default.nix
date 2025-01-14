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
    package =
      let
        nullPkg = pkgs.callPackage ../pkgs/null { };
      in
      lib.mkIf (!isMac && !isNixOs) nullPkg;
    settings = {
      terminal.shell = lib.mkIf (!isMac) "${pkgs.fish}/bin/fish";
      window = {
        option_as_alt = lib.mkIf isMac "Both";
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        normal = {
          family = if isMac then "monaco" else "jetbrains mono";
        };
        size = 10.6;
        offset.y = 3;
      };
    };
  };
}

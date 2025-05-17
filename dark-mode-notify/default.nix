{
  pkgs,
  lib,
  isMac,
  ...
}:
let
  script = pkgs.writeShellScript "alacritty-theme-toggle" ''
    TARGET="''${HOME}/.config/alacritty/theme.toml"
    if [ "$DARKMODE" -eq "1" ]; then
      ln -sf ${../alacritty/themes/dark.toml} "''${TARGET}"
    else
      ln -sf ${../alacritty/themes/light.toml} "''${TARGET}"
    fi
  '';
  plist = pkgs.substituteAll {
    src = ./ke.bou.dark-mode-notify.plist;
    bin = lib.getExe pkgs.dark-mode-notify;
    arguments = lib.concatStringsSep "\n" (
      builtins.map (arg: "<string>${arg}</string>") [
        script
      ]
    );
  };
in
lib.mkIf isMac {
  home.file."Library/LaunchAgents/ke.bou.dark-mode-notify.plist".source = plist;
}

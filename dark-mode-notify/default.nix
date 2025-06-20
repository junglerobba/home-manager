{
  pkgs,
  lib,
  isLinux,
  isMac,
  darwin,
  ...
}:
let
  script = pkgs.alacritty-theme-toggle;
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
# for standalone home-manager usage on mac without nix-darwin
# load with `launchctl load -w ~/Library/LaunchAgents/ke.bou.dark-mode-notify.plist`
lib.mkIf (isMac && !darwin) {
  home.file."Library/LaunchAgents/ke.bou.dark-mode-notify.plist".source = plist;
}
// lib.mkIf isLinux {
  systemd.user.services.dark-mode-notify = {
    Unit = {
      Description = "Monitor dark mode setting";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      ExecStart = ''
        ${lib.getExe pkgs.dbus-settings-portal-monitor} \
          --key org.freedesktop.appearance \
          --setting color-scheme \
          --env DARKMODE \
          --cmd ${script}
      '';
    };
  };
}

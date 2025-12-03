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
  plist = pkgs.replaceVars ./ke.bou.dark-mode-notify.plist {
    bin = lib.getExe pkgs.dark-mode-notify;
    arguments = lib.concatStringsSep "\n" (
      builtins.map (arg: "<string>${arg}</string>") [
        script
      ]
    );
  };
  path = "Library/LaunchAgents/ke.bou.dark-mode-notify.plist";
in
lib.mkMerge [
  # for standalone home-manager usage on mac without nix-darwin
  (lib.mkIf (isMac && !darwin) {
    home.file.${path}.source = plist;
    home.activation.dark-mode-notify = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run /bin/launchctl unload ~/${path} || true
      run /bin/launchctl load -w ~/${path}
    '';
  })
  (lib.mkIf isLinux {
    systemd.user.services.dark-mode-notify = {
      Unit = {
        Description = "Monitor dark mode setting";
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
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
  })
]

{
  pkgs,
  lib,
  isLinux,
  isMac,
  ...
}:
let
  script = pkgs.alacritty-theme-toggle;
in
{
  launchd.agents.dark-mode-notify = {
    enable = true;
    config = {
      ProgramArguments = [
        (lib.getExe pkgs.dark-mode-notify)
        "${script}"
      ];
      StandardErrorPath = "/tmp/ke.bou.dark-mode-notify.stderr";
      StandardOutPath = "/tmp/ke.bou.dark-mode-notify.stdout";
      KeepAlive = true;
    };
  };

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

}

{
  pkgs,
  lib,
  ...
}:
{
  launchd.user.agents =
    let
      dark-mode = "ke.bou.dark-mode-notify";
    in
    {
      "${dark-mode}" = {
        serviceConfig =
          let
            script = pkgs.alacritty-theme-toggle;
          in
          {
            Label = dark-mode;
            KeepAlive = true;
            StandardErrorPath = "/tmp/${dark-mode}.stderr";
            StandardOutPath = "/tmp/${dark-mode}.stdout";
            ProgramArguments = [
              (lib.getExe pkgs.dark-mode-notify)
              "${script}"
            ];
          };
      };
    };
}

{
  pkgs,
  lib,
  username,
  ...
}:

{

  nix.package = pkgs.lixPackageSets.stable.lix;

  nix.extraOptions =
    ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  nix.settings.trusted-users = [
    "@admin"
  ];

  environment.systemPackages = with pkgs; [
    alacritty
    gimp
  ];

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

  system.primaryUser = username;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.stateVersion = 6;
}

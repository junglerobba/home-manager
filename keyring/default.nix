{
  lib,
  pkgs,
  desktop,
  ...
}:
let
  isSway = desktop == "sway";
in
lib.mkIf isSway {
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
}

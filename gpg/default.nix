{
  pkgs,
  lib,
  isMac,
  ...
}:
lib.mkIf isMac {
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
  };
}

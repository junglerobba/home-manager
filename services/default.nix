{
  lib,
  isLinux,
  ...
}:
lib.mkIf isLinux {
  services.steam-dl-inhibit.enable = true;
}

{
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:
rustPlatform.buildRustPackage {
  pname = "dbus-settings-portal-monitor";
  version = "0.1.0";

  src = lib.cleanSource ./.;
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = [
    dbus
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  meta.mainProgram = "dbus-settings-portal-monitor";
}

(builtins.map
  (
    pkg:
    (final: prev: {
      "${pkg}" = final.callPackage pkgs/${pkg} { };
    })
  )
  [
    "dbus-settings-portal-monitor"
    "flatpak-cargo-generator"
    "kotlin-lsp"
    "null"
  ]
)
++ (builtins.map
  (
    pkg:
    (final: prev: {
      "${pkg}" = import ./overlays/${pkg} final prev;
    })
  )
  [
    "adwaita-fonts"
    "mpv"
    "jujutsu"
  ]
)

(builtins.map
  (
    pkg:
    (final: prev: {
      "${pkg}" = final.callPackage pkgs/${pkg} { };
    })
  )
  [
    "alacritty-theme-toggle"
    "dbus-settings-portal-monitor"
    "flatpak-cargo-generator"
    "kotlin-lsp"
    "multicursor-nvim"
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
    "mpv"
    "jujutsu"
  ]
)

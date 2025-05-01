(builtins.map
  (
    pkg:
    (final: prev: {
      "${pkg}" = final.callPackage pkgs/${pkg} { };
    })
  )
  [
    "flatpak-cargo-generator"
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
  ]
)

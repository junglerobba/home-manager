(map
  (
    pkg:
    (final: prev: {
      "${pkg}" = final.callPackage pkgs/${pkg} { };
    })
  )
  [
    "null"
  ]
)
++ (map
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

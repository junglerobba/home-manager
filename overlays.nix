let
  flatpak-cargo-generator =
    pkgs:
    with pkgs;
    let
      python = python3.withPackages (
        p: with p; [
          aiohttp
          toml
        ]
      );
    in
    stdenv.mkDerivation rec {
      name = "flatpak-cargo-generator";
      src =
        fetchFromGitHub {
          owner = "flatpak";
          repo = "flatpak-builder-tools";
          rev = "338ce9c6512d49d98ae9a508d219ffe19b5144e8";
          sha256 = "sha256-O4tXlkR7FmoqMC3jZZGrO19Ds0KUV07bWLqMMrFYL7w=";
        }
        + "/cargo/flatpak-cargo-generator.py";
      dontUnpack = true;
      dontBuild = true;
      nativeBuildInputs = [ python ];
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/${name}
        patchShebangs --build $out/bin/${name}
        chmod a+x $out/bin/${name}

        runHook postInstall
      '';
    };
in
[
  (final: prev: {
    mpv =
      if final.stdenv.hostPlatform.isLinux then
        prev.mpv.override { scripts = [ final.mpvScripts.mpris ]; }
      else
        prev.mpv;
  })
  (final: prev: { flatpak-cargo-generator = flatpak-cargo-generator final; })
]

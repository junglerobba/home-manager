{
  stdenv,
  python3,
  fetchFromGitHub,
}:
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
  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "flatpak-builder-tools";
    rev = "93ba2962f6ef9cdd7a2f40f48cd6e9864e375346";
    hash = "sha256-/3CDFR5sDHkB+lxlvy/SesBBBzNln3t+zf5A5l9yqg8=";
  };
  dontUnpack = true;
  dontBuild = true;
  nativeBuildInputs = [ python ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src/cargo/flatpak-cargo-generator.py $out/bin/${name}
    patchShebangs --build $out/bin/${name}
    chmod a+x $out/bin/${name}

    runHook postInstall
  '';
}

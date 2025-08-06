{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  temurin-jre-bin,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "0.253.10629";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-${version}.zip";
    hash = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r $src/* $out

    chmod +x $out/kotlin-lsp.sh
    makeWrapper $out/kotlin-lsp.sh \
      $out/bin/kotlin-lsp \
      --prefix PATH : ${lib.makeBinPath [ temurin-jre-bin ]}

    runHook postInstall
  '';
}

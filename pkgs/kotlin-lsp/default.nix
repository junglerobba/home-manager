{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  temurin-jre-bin,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "0.252.17811";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-${version}.zip";
    hash = "sha256-yplwz3SQzUIYaOoqkvPEy8nQ5p3U/e1O49WNxaE7p9Y=";
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

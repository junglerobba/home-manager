{ stdenv, ... }:
stdenv.mkDerivation {
  name = "null";
  dontUnpack = true;
  buildPhase = ''
    mkdir -p $out
  '';
}

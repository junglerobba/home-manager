{
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "null";
  dontUnpack = true;
  buildPhase = ''
    mkdir -p $out
  '';
}

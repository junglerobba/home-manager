final: prev:
if final.stdenv.hostPlatform.isLinux then
  prev.mpv.override { scripts = [ final.mpvScripts.mpris ]; }
else
  prev.mpv

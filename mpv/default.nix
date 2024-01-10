{ isMac, ... }: {
  programs.mpv = {
    enable = isMac;
    config = {
      keep-open = true;
      audio-display = false;
    };
  };
}

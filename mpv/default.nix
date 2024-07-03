{
  pkgs,
  isLinux,
  nixGL,
  ...
}:
{
  programs.mpv = {
    enable = true;
    package = nixGL pkgs.mpv;
    config =
      {
        keep-open = true;
        audio-display = false;
        osd-font = "roboto";
        osd-font-size = 15;
        sub-font = "roboto";
        sub-font-size = 36;
      }
      // (
        if isLinux then
          {
            vo = "dmabuf-wayland";
            gpu-context = "wayland";
            hwdec = "vaapi";
          }
        else
          { }
      );
  };
}

{ ... }: {
  programs.htop = {
    enable = true;
    settings = {
      tree_view = true;
      hide_userland_threads = true;
      highlight_base_name = true;
    };
  };
}

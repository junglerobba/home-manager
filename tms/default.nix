{ pkgs, ... }:
{
  xdg.configFile."tms/config.toml".source = (pkgs.formats.toml { }).generate "tms" {
    switch_filter_unknown = true;
    session_sort_order = "LastAttached";
    clone_repo_switch = "Foreground";
    vcs_providers = [
      "jj"
      "git"
    ];
    search_dirs = [
      {
        path = "~/dev";
        depth = 2;
      }
      {
        path = "~/.config/home-manager";
        depth = 0;
      }
    ];
  };
}

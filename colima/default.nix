{ pkgs, isMac, ... }: {
  home.file = pkgs.lib.mkIf isMac {
    ".colima/_templates/default.yaml".source = ./template.yml;
  };
}

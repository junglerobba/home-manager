{ lib, isMac, ... }:
lib.mkIf isMac { home.file.".colima/_templates/default.yaml".source = ./template.yml; }

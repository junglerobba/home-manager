{
  pkgs,
  lib,
  isMac,
  isNixOs,
  ...
}:
{
  programs.git = {
    enable = true;
    package = if (!isNixOs) then pkgs.null else pkgs.gitFull;
    extraConfig = {
      commit.verbose = true;
      pull.rebase = true;
      rebase.autostash = true;
      init.defaultBranch = "main";
      sendemail = {
        annotate = "yes";
      };
      credential.helper = lib.mkIf isMac "osxkeychain";
    };
    aliases = {
      ignore = "update-index --assume-unchanged";
      unignore = "update-index --no-assume-unchanged";
      ignored = "!git ls-files -v | grep ^[[:lower:]]";
    };
    includes = [ { path = "~/.config/git/config.d/overrides"; } ];
  };
}

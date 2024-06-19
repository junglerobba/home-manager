{ pkgs, isMac, ... }:
{
  programs.git = {
    enable = true;
    package =
      let
        nullPkg = pkgs.stdenv.mkDerivation {
          name = "null";
          dontUnpack = true;
          buildPhase = ''
            mkdir -p $out
          '';
        };
      in
      if isMac then nullPkg else pkgs.gitFull;
    extraConfig = {
      commit.verbose = true;
      pull.rebase = true;
      rebase.autostash = true;
      init.defaultBranch = "main";
      sendemail = {
        annotate = "yes";
      };
      credential.helper = if isMac then "osxkeychain" else "libsecret";
    };
    aliases = {
      ignore = "update-index --assume-unchanged";
      unignore = "update-index --no-assume-unchanged";
      ignored = "!git ls-files -v | grep ^[[:lower:]]";
    };
    includes = [ { path = "~/.config/git/config.d/overrides"; } ];
  };
}

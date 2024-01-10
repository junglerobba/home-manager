{ isMac, ... }: {
  programs.git = {
    enable = isMac;
    userName = "Tobias Langendorf";
    userEmail = "junglerobba@jngl.one";
    signing = { key = "063BB04D11363703"; };
    extraConfig = {
      commit.verbose = true;
      pull.rebase = true;
      rebase.autostash = true;
      init.defaultBranch = "main";
    };
    aliases = {
      ignore = "update-index --assume-unchanged";
      unignore = "update-index --no-assume-unchanged";
      ignored = "!git ls-files -v | grep ^[[:lower:]]";
    };
    ignores = [ "shell.nix" ".envrc" ];
  };
}

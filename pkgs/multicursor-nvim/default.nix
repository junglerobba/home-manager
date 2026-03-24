{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  name = "multicursor-nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "704b99f10a72cc05d370cfeb294ff83412a8ab55";
    sha256 = "sha256-JHl8Z7ESrWus2I6Pe+6gmdgCAZOzAKX7kimy71sAoe4=";
  };
}

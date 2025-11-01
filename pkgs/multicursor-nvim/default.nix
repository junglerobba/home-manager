{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  name = "multicursor-nvim";
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "0c6ceae228bf209e8b8717df9de500770c4e7022";
    sha256 = "sha256-QhYUwFGYXoeXr2dRraHvpYx4z/7R9TyL9OC2sGmIAMY=";
  };
}

{
  pkgs,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;

    defaultEditor = true;

    initLua = lib.fileContents ./init.lua;

    extraPackages = with pkgs; [
      ripgrep
      emmet-ls
      bash-language-server
      nixd
      yaml-language-server
      taplo
      dockerfile-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      lsp_signature-nvim
      vim-colorschemes
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = lib.fileContents ./treesitter.lua;
      }
      nvim-treesitter-textobjects
      nvim-treesitter-context
      {
        plugin = trouble-nvim;
        type = "lua";
        config = lib.fileContents ./trouble.lua;
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = lib.fileContents ./oil.lua;
      }
      {
        plugin = auto-save-nvim;
        type = "lua";
        config = lib.fileContents ./auto-save.lua;
      }
      {
        plugin = mini-nvim;
        type = "lua";
        config = lib.fileContents ./mini.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = lib.fileContents ./cmp.lua;
      }
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-cmdline
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = lib.fileContents ./lsp.lua;
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = lib.fileContents ./gitsigns.lua;
      }
      {
        plugin = conform-nvim;
        type = "lua";
        config = lib.fileContents ./conform.lua;
      }
      {
        plugin = leap-nvim;
        type = "lua";
        config = lib.fileContents ./leap.lua;
      }
      {
        plugin = lsp_signature-nvim;
        type = "lua";
        config = lib.fileContents ./lsp-signature.lua;
      }
      {
        plugin = pkgs.multicursor-nvim;
        type = "lua";
        config = lib.fileContents ./multicursor.lua;
      }
      {
        plugin = fwatch-nvim;
        type = "lua";
        config = lib.fileContents ./auto-theme.lua;
      }
    ];
  };
}

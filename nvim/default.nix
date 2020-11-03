{ lib, pkgs, ... }:
with lib;
let
  # Files to load into neovim
  nvimFiles = [ 
    ./init.vim
    ./coc-settings.vim
  ];

  # Packages loaded form nix packages
  nvimPackages = with pkgs.vimPlugins; [
    vim-plug
    vim-nix 
    vim-surround
    vim-airline
    vim-airline-themes
    gruvbox
  ];

  # Plugs for vim-plug
  nvimPlugs = [
    "'neoclide/coc.nvim', { 'branch': 'release'}"
    "'jackguo380/vim-lsp-cxx-highlight'"
    "'wlangstroth/vim-racket'"
  ];

  nvimGeneratedPlugs = 
    "call plug#begin('$HOME/.config/nvim/plugged')\n"  + 
    fold (plug: acc: acc + "Plug ${plug}\n") "" nvimPlugs + 
    "call plug#end()\n";
in
{
  enable = true;
  vimAlias = true;
  vimdiffAlias = true;
  configure = {
    customRC = nvimGeneratedPlugs + fold (file: acc: acc + (builtins.readFile file)) "" nvimFiles; 
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = nvimPackages;
    };
  };
}

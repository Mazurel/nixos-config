{ pkgs, lib, config, ... }:
let
  cfg = config.mazurel.development.neovim;

  # Files to load into neovim
  nvimFiles = [ nvim/coc-settings.vim nvim/init.vim ];

  # Packages loaded form nix packages
  nvimPackages = with pkgs.vimPlugins; [
    coc-nvim
    vim-racket
    vim-lsp-cxx-highlight
    vim-clang-format
    vim-nix
    vim-surround
    vim-airline
    vim-airline-themes
    vim-slime
    vim-gitgutter
    gruvbox
    nerdtree
    vim-nerdtree-syntax-highlight
    vim-devicons
    ctrlp-vim
  ];
in {
  options.mazurel.development.neovim.enable =
    lib.mkEnableOption "Enable my neovim config";

  options.mazurel.development.neovim.defaultEditor =
    lib.mkEnableOption "Make neovim default editor";

  config = lib.mkIf cfg.enable {
    environment.sessionVariables =
      lib.mkIf cfg.defaultEditor { EDITOR = "nvim"; };

    environment.systemPackages = with pkgs; [
      ccls
      rnix-lsp
      nodePackages.pyright
      nodePackages.typescript
      python38Packages.python-language-server
      nixfmt
    ];

    mazurel.home-manager = {
      # Installing and setting up proper neovim config
      xdg.configFile."nvim/coc-settings.json".source = nvim/coc-settings.json;
      programs.neovim = {
        enable = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins = nvimPackages;
        extraConfig =
          lib.fold (file: acc: acc + (builtins.readFile file)) "" nvimFiles;
      };
    };
  };
}

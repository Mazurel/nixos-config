{ lib, config, pkgs, ... }:
with lib;
let 
  # Files to load into neovim
  nvimFiles = [
    nvim/init.vim
    nvim/coc-settings.vim
  ];

  # Packages loaded form nix packages
  nvimPackages = with pkgs.vimPlugins; [
    coc-nvim
    vim-racket
    vim-lsp-cxx-highlight
    vim-nix
    vim-surround
    vim-airline
    vim-airline-themes
    gruvbox
    nerdtree
    vim-nerdtree-syntax-highlight
    vim-devicons
  ];

  # Run app 
  make-devour = name : { ${name} = "devour ${name}"; };
  devour-aliases = 
  [
    "wine"
    "xournalpp"
    "zathura"
    "thunar"
  ];
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mateusz";
  home.homeDirectory = "/home/mateusz";

  xdg.configFile."dunst/dunstrc".text = builtins.readFile ./dunstrc;

  xdg.configFile."dwm/autostart.sh" = {
    executable = true;
    text = ''
    #!/bin/sh
    xrandr --output HDMI1 --auto --left-of HDMI2

    nitrogen --restore
    WM_NAME=dwm slstatus &
    redshift-gtk &
    dunst &
    megasync &
    '';
  };

  home.packages = with pkgs; [
    clang

    # WM stuff
    redshift

    # Command line tools
    bat
    ripgrep
    htop
    killall
    cmakeCurses
    direnv
    
    # GUI
    obs-studio
  ];

  # Installing and setting up proper neovim config
  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile nvim/coc-settings.json;
  programs.neovim =
  {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    configure = {
      customRC = fold (file: acc: acc + (builtins.readFile file)) "" nvimFiles;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = nvimPackages;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    dotDir = ".config/zsh";
    initExtra = ''
    eval "$(direnv hook zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "aussiegeek";
    };

    shellAliases = {
      gst = "git status";
      ".." = "cd ..";
      "lsblk" = "lsblk -o name,mountpoint,label,size,uuid";
    } // lib.fold (x: acc: acc // (make-devour x)) {} devour-aliases;
  };

  programs.git = {
    enable = true;
    userName = "Mazurel";
    userEmail = "mateusz.mazur@yahoo.com";
    aliases = 
    {
      st = "status";
      cm = "commit";
      cmm = "commit -m";
      a = "add";
      rb = "rebase";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}

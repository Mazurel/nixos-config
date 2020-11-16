{ lib, config, pkgs, ... }:
with lib;
let 
  myTerm = "alacritty";

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
  make-devour = name : { ${name} = "devour ${name} 2> /dev/null 3> /dev/null"; };
  devour-aliases = 
  [
    "wine"
    "xournalpp"
    "zathura"
    "thunar"
    "nomacs"
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
    picom -b
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
    colorls
    
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
    oh-my-zsh = {
      enable = true;
      theme = "amuse";
    };

    plugins = [
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.1.0";
        sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
      };
    }
    ];

    shellAliases = {
      gst = "git status";
      ".." = "cd ..";
      "lsblk" = "lsblk -o name,mountpoint,label,size,uuid";
      "cls" = "colorls";
      "t" = "nohup ${myTerm} 2> /dev/null 3> /dev/null &";
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

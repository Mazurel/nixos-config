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
    vim-clang-format
    vim-nix
    vim-surround
    vim-airline
    vim-airline-themes
    vim-slime
    gruvbox
    nerdtree
    vim-nerdtree-syntax-highlight
    vim-devicons
    ctrlp-vim
  ];

  # Run app 
  make-devour = name : { ${name} = "devour ${name} 2> /dev/null 3> /dev/null"; };
  devour-aliases = 
  [
    "wine"
    "xournalpp"
    "zathura"
    "thunar"
    "imv"
    "vlc"
    "cvlc"
    "okular"
    "marktext"
    "sxiv"
  ];
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mateusz";
  home.homeDirectory = "/home/mateusz";

  xdg.configFile."dunst/dunstrc".text = builtins.readFile ./dunstrc;
  xdg.configFile."rofi/purple.rasi".text = builtins.readFile ./purple.rasi;
  xdg.configFile."rofi/config".text = "rofi.theme: ~/.config/rofi/purple.rasi";

  xdg.configFile."dwm/autostart.sh" = {
    executable = true;
    text = ''
    #!/usr/bin/env sh

    # Xrandr settings
    xrandr --output DP-0 --primary --mode 1920x1080 --left-of HDMI-0 --mode 1920x1080

    # Fixes programs such as scilab and matlab
    wmname LG3D

    nitrogen --restore
    WM_NAME=dwm slstatus &
    #redshift-gtk &
    dunst &
    megasync &
    nm-applet &
    barrier &
    '';
  };

  

  home.packages = with pkgs; [
    #clangd

    # WM stuff
    redshift
    feh
    polybar

    # Command line tools
    bat
    ripgrep
    htop
    killall
    cmakeCurses
    colorls
    manix
    dialog
    pandoc
    unrar
    wmname
    texlive.combined.scheme-full
    
    # GUI
    obs-studio
    ktorrent
    imv
    sxiv
    marktext
    gimp
    thunderbird
    xournalpp
    neovim-qt
    spotify

    # Science stuff
    maxima
    wxmaxima
    scilab-bin
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

    initExtra = ''
      cal
    '';

    plugins = [
    rec {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = name;
        rev = "v0.1.0";
        sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
      };
    }
    rec {
      name = "zsh-vim-mode";
      file = "${name}.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "softmoth";
        repo = name;
        rev = "abef0c0c03506009b56bb94260f846163c4f287a";
        sha256 = "0cnjazclz1kyi13m078ca2v6l8pg4y8jjrry6mkvszd383dx1wib";
      };
    }
    rec {
      name = "zsh-syntax-highlighting";
      file = "${name}.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = name;
        rev = "00a5fd11eb9d1c163fb49da5310c8f4b09fb3022";
        sha256 = "1gv7cl4kyqyjgyn3i6dx9jr5qsvr7dx1vckwv5xg97h81hg884rn";
      };
    }
    rec {
      name = "zsh-autosuggestions";
      file = "${name}.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = name;
        rev = "ae315ded4dba10685dbbafbfa2ff3c1aefeb490d";
        sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
      };
    }
    ];

    shellAliases = {
      gst = "git status";
      ".." = "cd ..";
      "lsblk" = "lsblk -o name,mountpoint,label,size,uuid";
      "cls" = "colorls";
      "t" = "nohup ${myTerm} 2> /dev/null 3> /dev/null &";
      "untar" = "tar -xvf";
      "mv" = "mv -v";
      "cp" = "cp -v";
      "rm" = "rm -v";
    }
    # Add all devour aliases
    // lib.fold (x: acc: acc // (make-devour x)) {} devour-aliases;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      character.symbol = "➜";
      time.disabled = false;
    };
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

  services.redshift = {
    enable = true;
    provider = "geoclue2";
    tray = true;
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

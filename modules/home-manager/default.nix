data:
{ lib, pkgs, ... }:
with lib;
let
  myTerm = "alacritty";

  # Run app 
  make-devour = name: { ${name} = "devour ${name} 2> /dev/null 3> /dev/null"; };
  devour-aliases = [
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
in (lib.attrsets.recursiveUpdate {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mateusz";
  home.homeDirectory = "/home/mateusz";

  xdg.configFile."dunst/dunstrc".source = ./dunstrc;
  xdg.configFile."rofi/purple.rasi".source = ./purple.rasi;
  xdg.configFile."rofi/config".text = "rofi.theme: ~/.config/rofi/purple.rasi";
  xdg.configFile."i3/".source = ./i3;
  xdg.configFile."polybar/config".source = ./polybar-config;

  home.packages = with pkgs; [
    # Command line tools
    bat
    ripgrep
    htop
    killall
    cmakeCurses
    manix
    dialog
    pandoc
    unrar
    wmname
    exa
    direnv
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    dotDir = ".config/zsh";

    initExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi

      cal
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
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
      "ls" = "exa";
      "t" = "nohup ${myTerm} 2> /dev/null 3> /dev/null &";
      "untar" = "tar -xvf";
      "mv" = "mv -v";
      "cp" = "cp -v";
      "rm" = "rm -v";
      "ed" = "emacs -nw";
    }
    # Add all devour aliases
      // lib.fold (x: acc: acc // (make-devour x)) { } devour-aliases;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = { time.disabled = false; };
  };

  programs.git = {
    enable = true;
    userName = "Mazurel";
    userEmail = "mateusz.mazur@yahoo.com";
    aliases = {
      st = "status";
      cm = "commit";
      cmm = "commit -m";
      a = "add";
      rb = "rebase";
    };
  };

  # Enable ssh (mostly for git)
  programs.ssh.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
} data)

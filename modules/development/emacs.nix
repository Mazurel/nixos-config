{ pkgs, lib, config, ... }:
let
  cfg = config.mazurel.development.emacs;

  my-emacs = pkgs.callPackage ./emacs { };
in {
  options.mazurel.development.emacs.enable =
    lib.mkEnableOption "Enable my Emacs package and config";

  options.mazurel.development.emacs.defaultEditor =
    lib.mkEnableOption "Make emacs (terminal version) a default editor";

  config = lib.mkIf cfg.enable {
    environment.sessionVariables =
      lib.mkIf cfg.defaultEditor { EDITOR = "emacs -nw"; };

    environment.systemPackages = with pkgs; [
      my-emacs.emacs

      ccls
      rnix-lsp
      nodePackages.pyright
      nodePackages.typescript
      python38Packages.python-language-server
      nixfmt
    ];

    mazurel.home-manager = {
      xdg.configFile."emacs/init.el".source = ./emacs/init.el;
      xdg.configFile."emacs/keybindings.el".source = ./emacs/keybindings.el;
      #xdg.configFile."emacs/exwm.el".source = ./emacs/exwm.el;
    };
  };
}

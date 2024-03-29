{ pkgs, lib, config, ... }:
let
  cfg = config.mazurel.development.emacs;

  my-emacs = pkgs.callPackage ./emacs { };

  customEmacsInit = ''
  (setq lsp-dart-sdk-dir "${pkgs.dart}/")
  '';
in {
  options.mazurel.development.emacs.enable =
    lib.mkEnableOption "Enable my Emacs package and config";

  options.mazurel.development.emacs.defaultEditor =
    lib.mkEnableOption "Make emacs (terminal version) a default editor";

  # TODO: Implement this thing
  options.mazurel.development.emacs.additionalCustomization =
    lib.mkOption {
      description = ''
      Contains custom packages and configuration that should be attached to the
      Emacs instance.
      '';
      
      type = lib.types.listOf (lib.types.submodule ({ config, ...}: {
        additionalInit = lib.mkOption {
          description = "Custom emacs code to be run";
          type = lib.types.string;
          default = "";
        };

        additionalPackages = lib.mkOption {
          description = "Custom packages that should be avaible to emacs instance";
          type = lib.types.listOf lib.types.package;
          default = [];
        };
      }));

      default = [];
    };
  
  config = lib.mkIf cfg.enable {
    environment.sessionVariables =
      lib.mkIf cfg.defaultEditor { EDITOR = "emacs"; };

    environment.systemPackages = with pkgs; [
      my-emacs.emacs

      ccls
      clang-tools
      rnix-lsp
      nodePackages.typescript
      nodePackages.pyright
      nix-direnv
      
      nixfmt
      swiProlog

      cargo
      rustc
    ];

    mazurel.home-manager = {
      xdg.configFile."emacs/init.el".source = ./emacs/init.el;
      xdg.configFile."emacs/keybindings.el".source = ./emacs/keybindings.el;
      xdg.configFile."emacs/dired-guess.el".source = ./emacs/dired-guess.el;
      xdg.configFile."emacs/custom-init.el".text = customEmacsInit;
      xdg.configFile."emacs/scad-mode.el".source = ./emacs/scad-mode.el;
    };
  };
}

# My usual packages for wms
{ lib, pkgs, config, ... }:
let
  cfg = config.mazurel.xorg.wms.common.packages;
  my-scripts = pkgs.callPackage ../../../scripts { };
in {
  options.mazurel.xorg.wms.common.packages.enable =
    lib.mkEnableOption "Enable my default wm's package suite";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      polybar
      rofi
      alacritty
      feh
      dunst
      dmenu
      lxappearance
    ];

    programs.qt5ct.enable = true;

    environment.sessionVariables = {
      GDK_PIXBUF_MODULE_FILE =
        "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
    };

    services.gnome.gnome-keyring.enable = true;

    mazurel.home-manager.systemd.user.services = {
#      dunst = {
#        enable = true;
#        unitConfig = {
#          type = "simple";
#        };
#
#        serviceConfig = {
#          ExecStart = "${dunst}/bin/dunst";
#        };
#
#        wantedBy = [ ];
#      };
    };
  };
}

# This is not patched well sadly
# TODO: Port to dwm-flexipatch
{ lib, pkgs, config, ... }:
let
  cfg = config.mazurel.wayland.wms.sway;

in
{
  options.mazurel.wayland.wms.sway.enable = lib.mkEnableOption "Enable sway WM";

  config = lib.mkIf cfg.enable {

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako # notification daemon
        alacritty # Alacritty is the default terminal in the config
        dmenu
        wofi
        waybar
        lxappearance
        gtk-engine-murrine
        gtk_engines
        gsettings-desktop-schemas
        flameshot
        swaylock
        firefox-wayland
      ];
    };

    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
    };

    services.gnome.gnome-keyring.enable = true;

    programs.qt5ct.enable = true;

    mazurel.home-manager = {
      home.packages = with pkgs; [ megasync networkmanagerapplet ];

      xdg.configFile."sway".source = ./sway;
      xdg.configFile."waybar".source = ./waybar;
    };
  };
}

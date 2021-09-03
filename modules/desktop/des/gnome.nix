{ pkgs, config, lib, ... }:
let cfg = config.mazurel.xorg.des.gnome;
in {
  options.mazurel.xorg.des.gnome.enable =
    lib.mkEnableOption "Enable my default gnome config";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    # Exclude all the packages
    #services.gnome.core-utilities.enable = false;

    environment.systemPackages = with pkgs; [
      alacritty
      gnome.nautilus
      gnome.sushi
      gnome.gnome-tweaks

      gnomeExtensions.gsconnect

      touchegg
      gnomeExtensions.x11-gestures
      gnomeExtensions.maximize-to-workspace-with-history
    ];

    programs.qt5ct.enable = true;
  };
}

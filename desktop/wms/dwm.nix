# This is not patched well sadly
# TODO: Port to dwm-flexipatch
{ lib, pkgs, config, ... }:
let
  cfg = config.mazurel.xorg.wms.dwm;

  dwm-src = pkgs.fetchFromGitHub {
    owner = "Mazurel";
    repo = "dwm";
    rev = "c5ffd76d4813d7a5bcd7ad4aa916fff6404c5b31";
    sha256 = "1wp2ardc1hbdkk2pd2x0p6kkfs9wmw62ic1gapv1k8gs79j8xb67";
  };

in {
  options.mazurel.xorg.wms.dwm.enable = lib.mkEnableOption "Enable dwm wm";

  config = lib.mkIf cfg.enable {
    mazurel.xorg.wms.common.packages.enable = true;
    mazurel.xorg.wms.common.xautolock.enable = true;
    mazurel.xorg.wms.common.picom.enable = true;

    nixpkgs = {
      config = {
        packageOverrides = pkgs: rec {
          # Overrides dwm as dwm-git
          dwm = pkgs.dwm-git.overrideAttrs (oldAttr: {
            name = "dwm-custom";
            src = dwm-src;
          });
          dwm-git = dwm;
        };

        dwm.conf = builtins.readFile configs/dwm-config.h;
        slstatus.conf = builtins.readFile configs/slstatus-config.h;
      };
    };

    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;
      windowManager.dwm.enable = true;
    };

    mazurel.home-manager = {
      home.packages = with pkgs; [ megasync networkmanagerapplet ];

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
          # Redshift is managed via configuration.nix
          # redshift-gtk & 
          dunst &
          megasync &
          nm-applet &
          barrier &
          kdeconnect-indicator &
        '';
      };
    };
  };
}

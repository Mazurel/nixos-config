# This is not patched well sadly
# TODO: Port to dwm-flexipatch
{ lib, pkgs, ... }:
let
  dwm-src = fetchFromGitHub {
      owner = "Mazurel";
      repo = "dwm";
      rev = "c5ffd76d4813d7a5bcd7ad4aa916fff6404c5b31";
      sha256 = "1wp2ardc1hbdkk2pd2x0p6kkfs9wmw62ic1gapv1k8gs79j8xb67";
    };
in
{
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

    xautolock = {
      enable = true;
      time = 10; # in minutes
      locker = "${my-scripts}/bin/locker";

      killtime = 60;
      killer = "/run/current-system/systemd/bin/systemctl suspend";
    };
  };

  environment.sessionVariables = {
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  };

  services.picom = {
    enable = true;
    fade = true;
    opacityRules = [ 
      "97:class_g = 'Alacritty' && focused"
      "95:class_g = 'Alacritty' && !focused"
    ];
    experimentalBackends = true;
    shadow = true;
    backend = "glx";
    fadeDelta = 5;
    settings = {
      no-dock-shadow = true;
      detect-rounded-corners = true;
      use-ewmh-active-win = true;
    };
  };


  programs.qt5ct.enable = true;
}

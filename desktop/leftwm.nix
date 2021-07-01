{ pkgs, ... }:
let
  my-scripts = pkgs.callPackage ../scripts {};
in
{
  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;
    windowManager.leftwm.enable = true;

    xautolock = {
      enable = true;
      time = 30; # in minutes
      locker = "${my-scripts}/bin/locker";

      killtime = 60;
      killer = "/run/current-system/systemd/bin/systemctl suspend";
    };
  };
  
  environment.systemPackages = with pkgs; [
    polybar
    rofi
    alacritty
    feh
  ];

  services.picom = {
    enable = true;
    fade = true;
    opacityRules = [ 
      "97:class_g = 'Alacritty' && focused"
      "95:class_g = 'Alacritty' && !focused"
      "97:class_g = 'Emacs' && focused"
      "95:class_g = 'Emacs' && !focused"
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
}

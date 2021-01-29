{ pkgs, ... }:
with pkgs;
{
#  nixpkgs.config.packageOverrides = pkgs: rec {
#    steam = pkgs.steam.override { 
#      extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib gcc mesa ]; 
#      nativeOnly = false; 
#    };
#  };


  # Required packages
  environment.systemPackages = [ 
    # Wine
    wineWowPackages.full
    winetricks
    # Games
    steam
    steam-run-native
    minecraft
    freesweep
    lutris
  ];

  # Steam hardware configuration
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = [ mesa amdvlk ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgsi686Linux; [ amdvlk libva ];
  hardware.pulseaudio.support32Bit = true;
}

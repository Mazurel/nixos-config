{ pkgs, ... }:
{
  # Required packages
  environment.systemPackages = with pkgs; [ 
    # Wine
    wineWowPackages.full
    winetricks
    # Games
    (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib libstdcxx5 gcc mesa ]; nativeOnly = true; })
    steam-run-native
    minecraft
  ];

  # Steam hardware configuration
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [ mesa ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
}

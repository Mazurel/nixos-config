{ pkgs, ... }:
{
  nixpkgs.overlays = [ (self: super: {
    steam = super.steam.overrideAttrs(old: rec { 
      pname = "steam-original";
      version = "1.0.0.69";
      src = pkgs.fetchurl {
        url = "https://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz";
        sha256 = "0ry7n95d0si1ph0lj1sxzlxvjswl0g9ffv3jp99zj4vb980ki63g";
      };
    });
  })];


  # Required packages
  environment.systemPackages = with pkgs; [ 
    # Wine
    wineWowPackages.full
    winetricks
    # Games
    steam
    minecraft
    freesweep
    lutris
  ];

  # Steam hardware configuration
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [ mesa amdvlk ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ amdvlk libva ];
  hardware.pulseaudio.support32Bit = true;
}

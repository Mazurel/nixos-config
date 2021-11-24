{ pkgs, ... }: {
  #  nixpkgs.overlays = [ (self: super: {
  #    ssteam = super.steam.overrideAttrs(old: rec { 
  #      pname = "steam-original";
  #      version = "1.0.0.69";
  #      src = pkgs.fetchurl {
  #        url = "https://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz";
  #        sha256 = "0ry7n95d0si1ph0lj1sxzlxvjswl0g9ffv3jp99zj4vb980ki63g";
  #      };
  #    });
  #  })];

  # Required packages
  environment.systemPackages = with pkgs; [
    # Wine
    wineWowPackages.full
    winetricks
    # Games
    (steam.override {
      extraProfile = ''
        unset VK_ICD_FILENAMES 
        export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/radeon_icd.i686.json:${amdvlk}/share/vulkan/icd.d/amd_icd64.json:${driversi686Linux.amdvlk}/share/vulkan/icd.d/amd_icd32.json
      '';
    }) # TODO: Remove override when  https://github.com/NixOS/nixpkgs/issues/108598#issuecomment-882847374 is fixed.
    steam-run-native
    minecraft
    freesweep
    lutris
  ];

  # Steam hardware configuration
  programs.steam.enable = true;
}

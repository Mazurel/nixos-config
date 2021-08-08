{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.lightdm.enable = true;
  };

  # Exclude all the packages
  services.gnome.core-utilities.enable = false;

  # Add packages necessary for this DE imo
  environment.systemPackages = with pkgs; [
    alacritty
    gnome.nautilus
    gnome.sushi
    gnome.gnome-tweaks
    
    gnomeExtensions.gsconnect
  ];

  programs.qt5ct.enable = true;
}

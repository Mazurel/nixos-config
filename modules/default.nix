# This is top module of all modules
{ lib, config, pkgs, ... }:
{
  imports = [
    # TODO: Modularize configuration.nix !
    ./configuration.nix
    
    ./hardware-configuration.nix

    ./user.nix
    ./packages.nix
    ./virtualization.nix
    ./desktop/steam-and-games.nix

    ./languages/polish.nix

    ./development/java.nix
    ./development/emacs.nix
    ./development/neovim.nix

    ./desktop/wms/dwm.nix
    ./desktop/wms/leftwm.nix
    ./desktop/wms/common/picom.nix
    ./desktop/wms/common/xautolock.nix
    ./desktop/wms/common/packages.nix
    ./desktop/des/gnome.nix
  ];

  nix.useSandbox = true;

  # Automatically clean and optimize store
  nix.autoOptimiseStore = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Packages settings
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  system.stateVersion = "20.09";
}


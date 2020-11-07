# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "Nixos-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";

  # Change interface if necessary
  networking.useDHCP = true;
  networking.interfaces.enp1s0.useDHCP = true;

  # Internationalization
  i18n.defaultLocale = "pl_PL.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  nixpkgs.config.packageOverrides = pkgs: rec {
    # Override dwm with custom settings
    # Overrides dwm as wel as dwm-git just to be sure
    dwm = pkgs.dwm-git.overrideAttrs (oldAttr: {
      name = "dwm-custom";
    });
    dwm-git = dwm;
  };

  # :< - for mailspring etc.
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.dwm.conf = builtins.readFile ./dwm/config.def.h;
  nixpkgs.config.dwm.patches = 
  [
    dwm/dwm-autostart-20161205-bb3bd6f.diff
    dwm/dwm-colorbar-6.2.diff
    dwm/dwm-sticky-6.1.diff
  ];

  nixpkgs.config.slstatus.conf = builtins.readFile ./slstatus/config.def.h;

  # X11 configuration
  services.xserver = 
  {
    enable = true;
    layout = "pl";
    # Disable touchpad
    libinput.enable = false;
    displayManager.sessionCommands = 
    ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1280x960
    '';
    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };
    windowManager.dwm.enable = true;
  };

  services.printing.enable = true;
  services.redshift.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
  };

  # User account. Don't forget to set a password with ‘passwd’.
  users.users.mateusz = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ]; # Enable ‘sudo’ for the user.
  }; 

  # Load home manager
  home-manager.users.mateusz = import ./home-manager;

  # $ nix search $pkg
  environment.systemPackages = with pkgs; [
    # WM etc
    alacritty
    xorg.libxcb
    arc-theme
    nitrogen
    slstatus
    rofi

    # Tools
    wget
    htop

    # Programming
    git
    gcc
    racket
    nodejs
    gtk2
    gtk3
    patchutils

    # Gui apps
    brave
    mailspring
    wine-staging

    # Fonts
    nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}


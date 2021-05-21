{ lib, config, pkgs, libsForQt514, ... }:
with pkgs;
let
  /* My custom packages */
  comma-pkg = pkgs.callPackage ./comma { };
  my-scripts = pkgs.callPackage ./scripts { };
  fluent-reader = pkgs.callPackage ./fluentReader.nix {  };

  # My settings implementation
  settings = import ./settings.nix {};

  my-python-packages = python-packages: with python-packages; [
    numpy
    matplotlib
    jedi
    sympy
    numba
    ipython
    tkinter
  ]; 

  python-with-my-packages = python3.withPackages my-python-packages;
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./boot.nix
      ./virtualization.nix
      ./steam-and-games.nix 
      ./packages.nix
      # TODO: Move i3wm, dwm and plasma to different modules
      <home-manager/nixos>
      <nixos-hardware/common/cpu/intel>
    ]
    ++ lib.optionals settings.wm.dwm ./dwm.nix;

  nix.useSandbox = true;
  nix.maxJobs = 4;
  nix.autoOptimiseStore = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Network settings
  networking = {
    hostName = "Nixos-desktop";

    networkmanager.enable = true;

    interfaces = {
      # Specific for device
      eno1.useDHCP = true;
    };

    wireless.enable = false; # Enables wpa_supplicant
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Time zone and location
  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";

  i18n.defaultLocale = "pl_PL.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  # Packages settings
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    emojione
    font-awesome
    source-code-pro
    noto-fonts
    liberation_ttf
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono"];
    })
  ];

  # X11 configuration
  services.xserver = 
  {
    enable = true;
    layout = "pl";
    #videoDrivers = [ "intel" ];
    videoDrivers = [ "intel" "amdgpu" ];
    #videoDrivers = [ "amdgpu" "intel" ];
    
    libinput.enable = false; # Touchpad
    windowManager.i3.enable = false;
    displayManager.sddm.enable = true; # For some reason it doesn't work
    displayManager.lightdm.enable = false;
    desktopManager.plasma5.enable = true;
  };


  # Enable sound.
  # TODO: Port to Pipewire
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Custom config for real time noise cancelation
    # Based on https://askubuntu.com/questions/18958/realtime-noise-removal-with-pulseaudio
    configFile = configs/default.pa;
  };

  # User account. Don't forget to set a password with ‘passwd’.
  users.users.mateusz = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" "networkmanager" "adbusers" ];
  }; 

  # Load home manager for main user
  home-manager.users.mateusz = import ./home-manager;

  environment.sessionVariables = {
    # Icons for gtk
    EDITOR = "vim";
    # Zsh-vim timeout
    KEYTIMEOUT = "10";
  };

  # Custom packages
  environment.systemPackages = 
    let OLDMEGASYNC = import (pkgs.fetchzip {
        url = "https://github.com/NixOS/nixpkgs/archive/4a7f99d55d299453a9c2397f90b33d1120669775.tar.gz";
        sha256 = "14sdgw2am5k66im2vwb8139k5zxiywh3wy6bgfqbrqx2p4zlc3m7"; }) { config = { allowUnfree=true; }; };
    in with pkgs; [
    python-with-my-packages
    comma-pkg
    my-scripts
    OLDMEGASYNC.megasync
    fluent-reader
  ];

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];
  services.teamviewer.enable = true;
  services.mullvad-vpn.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs.adb.enable = true;

  services.sshd.enable = true;
  services.gnome3.gnome-keyring.enable = true;

  # Temproarly disabled
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 80 443 24800 ]; # For http/https and Barrier
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # For kde connect
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # For kde connect

  system.stateVersion = "20.09";
}


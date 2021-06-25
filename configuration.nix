{ lib, config, pkgs, libsForQt514, ... }:
with pkgs;
let
  /* My custom packages */
  comma-pkg = pkgs.callPackage ./comma { };
  my-scripts = pkgs.callPackage ./scripts { };
  fluent-reader = pkgs.callPackage ./desktop/fluentReader.nix {  };
  tviti-matlab = pkgs.callPackage ./matlab { };
  my-emacs = pkgs.callPackage ./emacs { };

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
      ./desktop/steam-and-games.nix 
      ./packages.nix
      # TODO: Move i3wm, dwm and plasma to different modules
      <home-manager/nixos>
      <nixos-hardware/common/cpu/intel>
    ]
    ++ lib.optional settings.virtualization.enable ./virtualization.nix
    ++ lib.optional settings.wm.dwm ./desktop/dwm.nix
    ++ lib.optional settings.development.java ./development/java.nix;

  nix.useSandbox = true;
  nix.maxJobs = 4;

  # Automatically clean and optimize store
  nix.autoOptimiseStore = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Enable flakes :O
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Automatic upgrade of the system
  system.autoUpgrade.enable = true; 

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
      packageOverrides = pkgs: rec {
        # Overrides dwm as dwm-git
        krohnkite =  krohnkite.overrideAttrs (oldAttr: {
          buildInputs = oldAttr.buildInputs ++ [ nodePackages.typescript ];
        });
      };
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
    xkbOptions = "caps:ctrl_modifier,terminate:ctrl_alt_bksp";
    videoDrivers = [ "intel" "amdgpu" ];
    
    libinput.enable = false; # Touchpad
    windowManager.i3.enable = false;
    windowManager.exwm = {
      enable = true;
      enableDefaultConfig = false;
      extraPackages = my-emacs.emacs-packages;
      loadScript = ''
        (load "/home/mateusz/.emacs.d/exwm.el"
      '';
    };
    displayManager.sddm.enable = false; # For some reason it doesn't work
    displayManager.lightdm.enable = true;
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
    tviti-matlab.matlab
    plasma5Packages.krohnkite
  ];

  services.emacs = {
    enable = true;
    package = my-emacs.emacs;
    defaultEditor = true;
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];
  services.teamviewer.enable = true;
  services.mullvad-vpn.enable = true;
  #programs.corectrl.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs.adb.enable = true;

  services.sshd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.xserver.exportConfiguration = true;

  system.stateVersion = "20.09";
}


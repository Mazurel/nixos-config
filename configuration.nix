settings:
{ lib, config, pkgs, libsForQt514, ... }:
with pkgs;
let
  /* My custom packages */
  #comma-pkg = pkgs.callPackage ./comma { };
  my-scripts = pkgs.callPackage ./scripts { };
  fluent-reader = pkgs.callPackage ./desktop/fluentReader.nix {  };
  tviti-matlab = pkgs.callPackage ./matlab { };
  my-emacs = pkgs.callPackage ./emacs { };

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
  hy-with-my-packages = hy.withPackages my-python-packages;
in
{
  imports = (settings.lib settings).forAllApplySettings [ 
      ./hardware-configuration.nix
      ./boot.nix
      ./desktop/steam-and-games.nix 
      ./packages.nix

      # Settings based modules
      ./virtualization.nix
      # TODO: Move i3wm, dwm and plasma to different modules
    ]
    ++ lib.optional settings.wm.dwm ./desktop/dwm.nix
    ++ lib.optional settings.wm.leftwm ./desktop/leftwm.nix
    ++ lib.optional settings.de.gnome ./desktop/gnome.nix
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

  # Make CPU speed as fast as possible
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
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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
      enable = false;
      enableDefaultConfig = false;
      extraPackages = my-emacs.emacs-packages;
      loadScript = ''
        (load "/home/mateusz/.emacs.d/exwm.el"
      '';
    };
    displayManager.sddm.enable = false; # For some reason it doesn't work
    displayManager.lightdm.enable = true;
    desktopManager.plasma5.enable = false;
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

  users.users.root = {
    shell = pkgs.zsh;
  };

  environment.sessionVariables = {
    # Icons for gtk
    EDITOR = "emacs -nw";
    # Zsh-vim timeout
    KEYTIMEOUT = "10";
  };

  # Custom packages
  environment.systemPackages = [
    python-with-my-packages
    hy-with-my-packages
    #comma-pkg
    my-scripts
    megasync
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

  # At leas for now
  networking.firewall.enable = false;
  
  system.stateVersion = "20.09";
}


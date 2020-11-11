# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      <nixos-hardware/common/cpu/intel>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader = {
    grub = {
      enable = true;
      version = 2;

      # Efi config
      efiSupport = true;
      efiInstallAsRemovable = false;
      device = "nodev";

      # Specific for device
      extraEntries = ''
        menuentry "Arch" {
        search --set=arch --fs-uuid 7ede759b-7d19-4c66-b98d-e8d7b7497dc0
        configfile "($arch)/boot/grub/grub.cfg"
        }
      '';
    };

    efi.efiSysMountPoint = "/boot";
  };

  # Network settings
  networking = {
    hostName = "Nixos-desktop";
    useDHCP = true;

    interfaces = {
      # Specific for device
      eno1.useDHCP = true;
    };

    wireless.enable = false; # Enables wpa_supplicant
  };

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

      packageOverrides = pkgs: rec {
      # Overrides dwm as dwm-git
      dwm = pkgs.dwm-git.overrideAttrs (oldAttr: {
        name = "dwm-custom";
        });
      };

      # Dwm settings
      dwm = {
        conf = builtins.readFile window-manager/dwm/config.def.h;
        patches = 
        [
          window-manager/dwm/dwm-systray-6.2.diff
          window-manager/dwm/dwm-autostart-20161205-bb3bd6f.diff
          window-manager/dwm/dwm-sticky-6.1.diff
        ];
      };
      slstatus.conf = builtins.readFile window-manager/slstatus/config.def.h;

    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    source-code-pro
    noto-fonts
    noto-fonts-emoji
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
    videoDrivers = [ "nvidia" ];
    
    libinput.enable = false; # Touchpad

    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };

    windowManager.dwm.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Custom config for real time noise cancelation
    # Based on https://askubuntu.com/questions/18958/realtime-noise-removal-with-pulseaudio
    configFile = configs/default.pa;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  # User account. Don't forget to set a password with ‘passwd’.
  users.users.mateusz = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" ]; # Enable ‘sudo’ for the user.
  }; 

  # Load home manager for main user
  home-manager.users.mateusz = import ./home-manager;

  environment.sessionVariables = {
    # Icons for gtk
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  };

  environment.systemPackages = with pkgs; [
    # WM etc
    alacritty
    dunst
    nitrogen
    slstatus
    rofi

    # Themes and more
    capitaine-cursors
    arc-theme
    lxappearance

    # Night colors
    redshift
    hicolor-icon-theme

    # Tools
    wget
    htop
    devour

    # Programming
    git
    gcc
    racket
    nodejs
    patchutils

    # Wine
    wineWowPackages.stable

    # Gui apps
    brave
    minecraft
    xournalpp
    zathura
    qucs
    libreoffice-fresh
    pavucontrol
    xfce.thunar
    thunderbird-bin
    megasync
    steam

    # Virtualization
    virt-manager
    ebtables
    dnsmasq
  ];

  services.printing.enable = true;
  virtualisation.libvirtd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  system.stateVersion = "20.09";
}


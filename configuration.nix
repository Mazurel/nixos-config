{ lib, config, pkgs, ... }:
with pkgs;
let
  comma-pkg = import ./comma { inherit pkgs; };

  my-python-packages = python-packages: with python-packages; [
    numpy
    matplotlib
  ]; 

  python-with-my-packages = python3.withPackages my-python-packages;
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
      <nixos-hardware/common/cpu/intel>
    ];

  nix.useSandbox = true;
  nix.maxJobs = 4;

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
    efi.canTouchEfiVariables = true;
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
      dwm = pkgs.dwm-git.overrideAttrs (oldAttr: {
        name = "dwm-custom";
        src = fetchFromGitHub {
          owner = "Mazurel";
          repo = "dwm";
          rev = "4719907bf0ec2dddbabf6f0ea6f950bde6116f64";
          sha256 = "0plinyw5ff11i5gbpirqf7mjw6gcj8xn8hg0pm0paxlm7d71na2n";
        };
        });
      };

      dwm.conf = builtins.readFile window-manager/dwm-config.h;
      slstatus.conf = builtins.readFile window-manager/slstatus-config.h;
    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    font-awesome
    emojione
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
    videoDrivers = [ "nvidia" ];
    
    libinput.enable = false; # Touchpad

    displayManager.lightdm = {
      enable = true;
      #greeters.mini = {
      #  enable = true;
      #  user = "mateusz";
      #};
    };

    windowManager.dwm.enable = true;
    windowManager.leftwm.enable = true;
    
    xautolock = {
      enable = true;
      time = 10; # in minutes

      killtime = 60;
      killer = "/run/current-system/systemd/bin/systemctl suspend";
    };
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
    extraGroups = [ "wheel" "audio" "libvirtd" "networkmanager" ];
  }; 

  # Load home manager for main user
  home-manager.users.mateusz = import ./home-manager;

  environment.sessionVariables = {
    # Icons for gtk
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
    EDITOR = "vim";
    KEYTIMEOUT = "10";
  };

  environment.systemPackages = with pkgs; [
    # WM etc
    alacritty
    dunst
    nitrogen
    slstatus
    dmenu
    rofi
    picom
    networkmanagerapplet

    # Themes and more
    capitaine-cursors
    arc-theme
    lxappearance

    # Night colors
    redshift
    hicolor-icon-theme

    # Tools
    wget
    comma-pkg
    htop
    devour
    libnotify
    maim
    xclip
    file

    # Virtualization
    udev
    OVMF
    pciutils
    kvm

    # Programming
    git
    gcc
    gnumake
    pkgconfig
    clang
    clang-tools
    racket
    nodejs
    patchutils
    python-with-my-packages
    xlibs.xorgserver # Xephyr

    vscodium

    gtk2
    glade
    qt514.full

    # Wine
    wineWowPackages.full
    winetricks

    # Browser
    brave
    firefox

    # Office
    libreoffice-fresh
    zathura
    kdeApplications.okular
    nomacs
    gimp
    thunderbird-bin
    xournalpp

    # Science stuff
    maxima
    wxmaxima
    scilab-bin

    # Electronics
    qucs-s
    qucs
    ngspice

    # Other
    pavucontrol
    xfce.thunar
    megasync
    vlc
    discord
    teams
    gparted

    # Games
    (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib  libstdcxx5 ]; nativeOnly = false; })
    steam-run-native
    minecraft

    # Virtualization
    virt-manager
    ebtables
    dnsmasq
  ];

  services.printing.enable = true;
  services.teamviewer.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;
  virtualisation.libvirtd.qemuRunAsRoot = false;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  system.stateVersion = "20.09";
}


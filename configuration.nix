{ lib, config, pkgs, ... }:
with pkgs;
let
  comma-pkg = import ./comma { inherit pkgs; };
  my-scripts = import ./scripts { pkgs = pkgs; };

  my-python-packages = python-packages: with python-packages; [
    numpy
    matplotlib
    jedi
  ]; 

  python-with-my-packages = python3.withPackages my-python-packages;
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./boot.nix
      ./packages.nix
      ./virtualization.nix
      ./steam-and-games.nix
      <home-manager/nixos>
      <nixos-hardware/common/cpu/intel>
    ];

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

      dwm.conf = builtins.readFile configs/dwm-config.h;
      slstatus.conf = builtins.readFile configs/slstatus-config.h;
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

    #config = builtins.readFile configs/xorg.conf;
    
    libinput.enable = false; # Touchpad

    displayManager.lightdm = {
      enable = true;
    };

    windowManager.dwm.enable = true;
    windowManager.leftwm.enable = true;
    
    xautolock = {
      enable = true;
      time = 10; # in minutes
      locker = "${my-scripts}/bin/locker";

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
    # Zsh-vim timeout
    KEYTIMEOUT = "10";
  };

  # Custom packages
  environment.systemPackages = [
    python-with-my-packages
    comma-pkg
    my-scripts
  ];

  services.printing.enable = true;
  services.teamviewer.enable = true;
  services.picom = {
    enable = true;
    fade = true;
    opacityRules = [ 
      "97:class_g = 'Alacritty' && focused"
      "95:class_g = 'Alacritty' && !focused"
    ];
    experimentalBackends = true;
    shadow = true;
    backend = "glx";
    fadeDelta = 5;
    settings = {
      no-dock-shadow = true;
      detect-rounded-corners = true;
      use-ewmh-active-win = true;
#      detect-client-opacity = false;
#      corner-radius = 5;
#      blur-background-exclude = [
#        "window_type = 'dock'"
#        "window_type = 'desktop'"
#        "class_g = 'maim'"
#        "class_g = 'Maim'"
#      ];
#      blur = {
#        method = "gaussian";
#        size = 10;
#        deviation = 5.0;
#      };
    };
  };

  programs.qt5ct.enable = true;

  networking.firewall.enable = true;

  system.stateVersion = "20.09";
}


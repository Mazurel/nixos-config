# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./filesystems.nix
      <home-manager/nixos>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = false;
  boot.loader.grub.extraEntries = ''
  menuentry "Arch" {
    search --set=arch --fs-uuid 7ede759b-7d19-4c66-b98d-e8d7b7497dc0
    configfile "($arch)/boot/grub/grub.cfg"
    }
  '';

  boot.loader.efi.efiSysMountPoint = "/boot";

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

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

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.dwm = 
  {
    conf = builtins.readFile window-manager/dwm/config.def.h;
    patches = 
    [
      window-manager/dwm/dwm-systray-6.2.diff
      window-manager/dwm/dwm-autostart-20161205-bb3bd6f.diff
      window-manager/dwm/dwm-sticky-6.1.diff
    ];
  };

  nixpkgs.config.slstatus.conf = builtins.readFile window-manager/slstatus/config.def.h;

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
    # Disable touchpad
    libinput.enable = false;
    displayManager.sessionCommands = 
    ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1280x960
      #eval $(${lib.getBin pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
      export SSH_AUTH_SOCK
    '';
    displayManager.gdm = {
      enable = true;
      greeter.enable = true;
    };
    windowManager.dwm.enable = true;
  };

  services.printing.enable = true;

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
    thunderbird-bin

    # Night colors
    redshift
    hicolor-icon-theme

    # Tools
    wget
    htop

    # Programming
    git
    gcc
    racket
    nodejs
    patchutils

    # Gui apps
    brave
    wine-staging
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
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}


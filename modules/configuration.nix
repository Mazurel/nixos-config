{ lib, config, pkgs, ... }:
with pkgs;
let
  my-python-packages = python-packages:
    with python-packages; [
      numpy
      matplotlib
      jedi
      sympy
      numba
      ipython
      tkinter
      pygments
    ];

  python-with-my-packages = python3.withPackages my-python-packages;
  hy-with-my-packages = hy.withPackages my-python-packages;
in
{
  # Packages settings
  nixpkgs = { config = { android_sdk.accept_license = true; }; };

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
  services.xserver = {
    xkbOptions = "caps:ctrl_modifier,terminate:ctrl_alt_bksp";
  };

  # Enable sound.
  # TODO: Port to Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Old Pulseaudio:
  sound.enable = false;
  hardware.pulseaudio = {
    enable = false;
    # Custom config for real time noise cancelation
    # Based on https://askubuntu.com/questions/18958/realtime-noise-removal-with-pulseaudio
    configFile = configs/default.pa;
  };

  # User account. Don't forget to set a password with ‘passwd’.
  users.users.${config.mazurel.username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" "networkmanager" "adbusers" "docker" ];
  };

  users.users.root = { shell = pkgs.zsh; };

  environment.sessionVariables = {
    # Zsh-vim timeout
    KEYTIMEOUT = "10";
  };

  # Custom packages
  environment.systemPackages = [
    python-with-my-packages
    hy-with-my-packages
    comma
    mazurel-scripts
    megasync
    matlab

    (lyx.override {
      python3 = python-with-my-packages;
    })
  ];

  services.geoclue2.enable = true;
  services.geoclue2.appConfig."redshift".isAllowed = true;
  services.geoclue2.appConfig."redshift".isSystem = true;
  services.redshift.enable = true;
  location.provider = "geoclue2";

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];
  services.teamviewer.enable = true;
  # services.mullvad-vpn.enable = true;
  # programs.corectrl.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  programs.adb.enable = true;

  services.sshd.enable = true;
  services.xserver.exportConfiguration = true;
}

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
    ];

  python-with-my-packages = python3.withPackages my-python-packages;
  hy-with-my-packages = hy.withPackages my-python-packages;
in {
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
    enable = true;
    xkbOptions = "caps:ctrl_modifier,terminate:ctrl_alt_bksp";
    videoDrivers = [ "intel" "amdgpu" ];

    libinput.enable = true; # Touchpad
    windowManager.i3.enable = false;
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
  users.users.${config.mazurel.username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "libvirtd" "networkmanager" "adbusers" ];
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
  ];

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];
  services.teamviewer.enable = true;
  services.mullvad-vpn.enable = true;
  #programs.corectrl.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs.adb.enable = true;

  services.sshd.enable = true;
  services.xserver.exportConfiguration = true;
}


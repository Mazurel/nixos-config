{ pkgs, ... }:
with pkgs;
rec {
  environment.systemPackages = [
    # Window manager addons
    alacritty
    dunst
    nitrogen
    slstatus
    dmenu
    rofi
    networkmanagerapplet
    redshift

    # Themes and more
    capitaine-cursors
    arc-theme
    lxappearance
    marwaita-manjaro
    papirus-maia-icon-theme
    lxqt.lxqt-themes
    hicolor-icon-theme
    adwaita-qt

    # Tools
    bash
    neofetch
    wget
    htop
    devour
    libnotify
    maim
    xclip
    file
    xlibs.xorgserver # Xephyr

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
    glade

    vscodium
    nodePackages.pyright

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
    marktext

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

    # Virtualization
    virt-manager
    ebtables
    dnsmasq
  ];
}

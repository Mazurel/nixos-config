{ pkgs, ... }:
with pkgs;
rec {
  environment.systemPackages = [
    # WM etc
    alacritty
    dunst
    nitrogen
    slstatus
    dmenu
    rofi
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
    (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib libstdcxx5 gcc mesa ]; nativeOnly = true; })
    steam-run-native
    minecraft

    # Virtualization
    virt-manager
    ebtables
    dnsmasq
  ];
}

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
    autorandr

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
    unzip
    xlibs.xorgserver # Xephyr
    usbutils # lsusb

    # Virtualization
    udev
    OVMF
    pciutils
    kvm

    # Programming
    git
    gcc
    gdb
    gnumake
    pkgconfig
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
    sxiv
    marktext
    inkscape

    # Science stuff
    maxima
    wxmaxima
    scilab-bin

    # Electronics
    # qucs-s
    qucs
    ngspice

    # Other
    pavucontrol
    xfce.thunar
    megasync
    vlc
    kdenlive
    discord
    teams
    gparted
    barrier

    # Virtualization
    virt-manager
    ebtables
    dnsmasq
  ];
}

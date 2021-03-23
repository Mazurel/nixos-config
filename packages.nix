{ pkgs, ... }:
with pkgs;
rec {
  environment.systemPackages = [
    # Window manager addons
    alacritty
    polybarFull
    deadd-notification-center
    nitrogen
    slstatus
    dmenu
    rofi
    networkmanagerapplet
    redshift
    autorandr
    dragon-drop
    libsecret

    # Themes and more
    capitaine-cursors
    arc-theme
    lxappearance
    marwaita-manjaro
    papirus-maia-icon-theme
    lxqt.lxqt-themes
    hicolor-icon-theme
    adwaita-qt
    pop-gtk-theme

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
    jq # Json manipulation
    hardinfo # Hardware info
    anki
    ntfs3g
    tmux

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
    racket
    nodejs
    patchutils
    glade
    conda

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
    libsForQt5.okular
    libsForQt5.kdeconnect-kde
    sxiv
    inkscape
    slack
    texlive.combined.scheme-full
    mailspring
    obsidian
    kile
    ark
    lyx

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

    # GUI
    obs-studio
    ktorrent
    imv
    marktext
    gimp
    thunderbird
    xournalpp
    spotify
  ];
}

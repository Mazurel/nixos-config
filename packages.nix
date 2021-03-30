{ pkgs, ... }:
with pkgs;
let
  mkDict =
  { name, readmeFile, dictFileName, ... }@args:
  stdenv.mkDerivation ({
    inherit name;
    installPhase = ''
      # hunspell dicts
      install -dm755 "$out/share/hunspell"
      install -m644 ${dictFileName}.dic "$out/share/hunspell/"
      install -m644 ${dictFileName}.aff "$out/share/hunspell/"
      # myspell dicts symlinks
      install -dm755 "$out/share/myspell/dicts"
      ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
      ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
      # docs
      install -dm755 "$out/share/doc"
      install -m644 ${readmeFile} $out/share/doc/${name}.txt
      runHook postInstall
    '';
  } // args);

  mkDictFromLibreOffice =
    { shortName
    , shortDescription
    , dictFileName
    , license
    , readmeFile ? "README_${dictFileName}.txt"
    , sourceRoot ? dictFileName }:
    mkDict rec {
      name = "hunspell-dict-${shortName}-libreoffice-${version}";
      version = "6.3.0.4";
      inherit dictFileName readmeFile;
      src = fetchFromGitHub {
        owner = "LibreOffice";
        repo = "dictionaries";
        rev = "libreoffice-${version}";
        sha256 = "14z4b0grn7cw8l9s7sl6cgapbpwhn1b3gwc3kn6b0k4zl3dq7y63";
      };
      buildPhase = ''
        cp -a ${sourceRoot}/* .
      '';
      meta = with lib; {
        homepage = "https://wiki.documentfoundation.org/Development/Dictionaries";
        description = "Hunspell dictionary for ${shortDescription} from LibreOffice";
        license = license;
        maintainers = with maintainers; [ vlaci ];
        platforms = platforms.all;
      };
    };
in
rec {
  environment.systemPackages = [
    mullvad-vpn
    rnix-lsp

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

    # Languages
    aspell
    aspellDicts.pl
    aspellDicts.en

    hunspell
    hunspellDicts.en_GB-large
    (mkDictFromLibreOffice {
      shortName = "pl-pl";
      dictFileName = "pl_PL";
      shortDescription = "Polish (Poland)";
      readmeFile = "README_pl.txt";
      license = with lib.licenses; [ mpl20 lgpl3 ];
    })

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

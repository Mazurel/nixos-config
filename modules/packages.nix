{ pkgs, ... }:
with pkgs;
let
  mkDict = { name, readmeFile, dictFileName, ... }@args:
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

  mkDictFromLibreOffice = { shortName, shortDescription, dictFileName, license
    , readmeFile ? "README_${dictFileName}.txt", sourceRoot ? dictFileName }:
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
        homepage =
          "https://wiki.documentfoundation.org/Development/Dictionaries";
        description =
          "Hunspell dictionary for ${shortDescription} from LibreOffice";
        license = license;
        maintainers = with maintainers; [ vlaci ];
        platforms = platforms.all;
      };
    };
in rec {
  environment.systemPackages = [
    radeontop

    # Window manager addons
    #    alacritty
    #    polybarFull
    #    deadd-notification-center
    #    nitrogen
    #    slstatus
    dmenu
    #    rofi
    #    networkmanagerapplet
    #    redshift
    #    autorandr
    #    dragon-drop
    #    libsecret
    glib
    nix-index
    
    # Themes and more
    capitaine-cursors
    arc-theme
    papirus-maia-icon-theme
    hicolor-icon-theme
    adwaita-qt
    pop-gtk-theme
    qogir-theme
    qogir-icon-theme
    orchis-theme

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
    ntfs3g
    gnome3.librsvg # SVG parsing for LyX
    torrential
    brasero # For cd recording
    cdrkit # For cd recording
    imagemagick
    poppler_utils

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
      license = with lib.licenses; [ gpl2 mpl20 lgpl3 ];
    })

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
    nixfmt

    nodePackages.pyright

    # Wine
    wineWowPackages.full
    winetricks

    # Browser
    ungoogled-chromium
    firefox
    # nyxt

    # Office
    libreoffice-fresh
    # zathura
    libsForQt5.okular
    libsForQt5.kdeconnect-kde
    # sxiv
    inkscape-with-custom-extensions
    # slack
    (texlive.combine {
      inherit (texlive)
        collection-basic
        collection-latex
        collection-latexextra
        collection-latexrecommended
        collection-luatex
        collection-formatsextra
        collection-fontutils
        collection-fontsrecommended
        collection-langpolish
        minted;
    })
    mailspring
    # obsidian
    ark

    # Science stuff
    maxima
    wxmaxima
    swiProlog
    openscad

    # Electronics

    # qucs-s
    # ngspice

    # Other
    pavucontrol
    vlc
    kdenlive
    discord
    teams
    gparted
    barrier
    # mullvad-vpn
    openvpn
    super-productivity

    # GUI
    obs-studio
    ktorrent
    imv
    gimp
    xournalpp
    spotify
    element-desktop
    # anki
    drawio

    # Crypto I guess
    #    monero
    #    monero-gui
    #    xmrig

    # Photography
    darktable
  ];
}

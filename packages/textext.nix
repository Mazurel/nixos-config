{ lib
, stdenv
, fetchFromGitHub
, runCommand
, inkcut
, callPackage
, python3
, texlive
, inkscape
, gtk3
, gobject-introspection
  # Possibly user defined options:
, latexPackage ? texlive.combined.scheme-basic
, preferGtk ? true # If set to false then use tkinter instead
}:
stdenv.mkDerivation rec {
  name = "textext";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "textext";
    repo = "textext";
    rev = version;
    sha256 = "sha256-6kqjYzU4Nlr3e8NsyptszcvU08ZPyziAilDxyyUFzJc=";
  };

  nativeBuildInputs = lib.optionals preferGtk [
    gobject-introspection
  ];

  propagatedBuildInputs = [
    (python3.withPackages
      (ps: with ps;
        if preferGtk
        then [ pygobject3 ]
        else [ tkinter ]
      )
    )
    latexPackage
    inkscape
  ]
  ++ lib.optionals preferGtk [ gtk3 ];

  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/inkscape/extensions

    # Below there is a simple, but not really pretty solution for
    # building this extension.
    #
    # The problem is that the installer wants to create user config file
    # at install time. That is why it needs to patched so that it will use
    # some random directory inside build folder for that. Here the issue arises.
    # After installation, when plugin is being used, this extension
    # wants to use these settings, and that is why after using installer,
    # its source code needs to be patched so that it uses again local user
    # settings. Hope it will not be confusing for someone reading that.
 
    TMP_CONFIG_DIR=$(mktemp -d XXX)
 
    sed -i "s|~/\.config|$TMP_CONFIG_DIR|" textext/requirements_check.py

    python3 setup.py \
             --inkscape-extensions-path $out/share/inkscape/extensions
           
    find $out -exec sed -i "s|$TMP_CONFIG_DIR|~/\.config|" {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Re-editable LaTeX graphics for Inkscape ";
    homepage = "https://github.com/lifelike/hexmapextension";
    license = licenses.bsd3;
    maintainers = [ maintainers.mazurel ];
    platforms = platforms.all;
  };
}

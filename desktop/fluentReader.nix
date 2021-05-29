{ appimageTools, fetchurl, ... }:
appimageTools.wrapType1 {
  name = "Fluent-reader";
  src = fetchurl {
    url = "https://github.com/yang991178/fluent-reader/releases/download/v1.0.0/Fluent.Reader.1.0.0.AppImage";
    sha256 =  "1299h6x986pazd25z6g1mb1k27kdk3z7k603vnrlrrnm44hkk4dr";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications/ 
    cat >$out/share/applications/Fluent-reader.desktop <<EOL
    [Desktop Entry]
    Type=Application
    Name=Fluent-reader
    Path=$out/bin/Fluent-reader
    Exec=Fluent-reader
    Terminal=false
    Version=1.0
    Categories=Reader;Office;Rss;
    EOL
  '';

  extraPkgs = pkgs: with pkgs; [ ];
}

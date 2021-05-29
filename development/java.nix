{ pkgs, ... }:
{
  # Packages required for java development (I guess)
  # It provides netbeans and some usefull stuff
  # That is reuired for example for Java3D
  environment.systemPackages = with pkgs; [ 
    jdk8
    ant
    netbeans
    udev
    alsaLib
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXft
    xorg.libXxf86vm
    libxfs
  ];
}

{ pkgs, lib, config, ... }:
let
  cfg = config.mazurel.development.java;
in
{
  options.mazurel.development.java.enable = lib.mkEnableOption "Enable java development suite";
  
  # Packages required for java development (I guess)
  # It provides netbeans and some usefull stuff
  # That is required for example for Java3D
  config = lib.mkIf cfg.enable {
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
  };
}

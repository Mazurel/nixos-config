{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib, stdenv ? pkgs.stdenv, ... }:
# All it does is it compies all the scripts from src
with pkgs;
stdenv.mkDerivation {
  pname = "MyScripts";
  version = "1";
  src = ./src;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ yad i3lock ];

  installPhase = ''
    mkdir -p $out/bin
    install -t $out/bin ./*
    wrapProgram $out/bin/locker \
      --set SLEEP_TIMEOUT 10s \
      --prefix PATH : ${yad}/bin \
      --prefix PATH : ${i3lock}/bin
  '';
}

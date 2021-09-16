#!/usr/bin/env sh

# TODO: Fix this when https://github.com/NixOS/nix/pull/5189
#       will be merged

FILE=$(mktemp -t "screenshot_XXXX.png")
DIMENSIONS=$(nix run nixpkgs#slurp)

nix shell nixpkgs#grim nixpkgs#slurp --command grim -g "$DIMENSIONS" $FILE
nix shell nixpkgs#dragon-drop --command "dragon" $FILE

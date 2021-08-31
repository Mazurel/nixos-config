{ pkgs ? import <nixpkgs> { } }:
let
  myEmacs = pkgs.emacs;

in rec {
  emacs-packages = (epkgs:
    (with epkgs.melpaStablePackages; [
      magit
      zerodark-theme
      nix-mode
      groovy-mode
      evil
      which-key
      company

      doom-modeline
      dashboard

      ivy
      counsel
      swiper
    ]) ++ (with epkgs.melpaPackages; [
      spacemacs-theme
      vterm

      lsp-mode
      lsp-dart
      lsp-ui
      racket-mode
      all-the-icons-dired
      all-the-icons
    ]) ++ (with epkgs.elpaPackages; [ ]) ++ (with pkgs; [
      # Other maybe useful stuff
      racket
      nodejs
      nixfmt
      hy

      # Emacs LSP
      nodePackages.pyright
      nodePackages.eslint
      clang-tools
      rnix-lsp
      dart
      flutter

      emacs-all-the-icons-fonts
    ]));

  emacs = ((pkgs.emacsPackagesFor myEmacs).emacsWithPackages emacs-packages);

}


{ pkgs ? import <nixpkgs> { } }:
let
  myEmacs = pkgs.emacs;

in
rec {
  emacs-packages = (epkgs:
    (with epkgs.melpaStablePackages; [
      magit
      evil
      which-key
      company
      hl-todo # TODO and FIXME highlight

      doom-modeline # Better modeline
      dashboard # Emacs dashboard

      # Custom search mechanisms
      ivy
      counsel
      swiper

      # Language specific modes
      nix-mode
      groovy-mode
    ]) ++ (with epkgs.melpaPackages; [
      spacemacs-theme
      vterm

      # Language specific modes
      lsp-mode
      lsp-dart
      lsp-ui
      racket-mode
      matlab-mode
      rust-mode

      # Icons
      all-the-icons-dired
      all-the-icons
    ]) ++ (with epkgs.elpaPackages; [
      # Language specific modes
      ediprolog
    ]) ++ (with pkgs; [
      # Other maybe useful stuff
      racket
      nodejs
      nixfmt

      # Emacs LSP
      nodePackages.pyright
      nodePackages.eslint
      nodePackages.typescript
      clang-tools
      rnix-lsp
      dart
      flutter

      emacs-all-the-icons-fonts
    ]));

  emacs = ((pkgs.emacsPackagesFor myEmacs).emacsWithPackages emacs-packages);

}


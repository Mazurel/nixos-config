{ pkgs ? import <nixpkgs> {} }:
let
  myEmacs = pkgs.emacs; 
in rec {
  emacs-packages = (epkgs: (with epkgs.melpaStablePackages; [ 
    magit          
    zerodark-theme 
    nix-mode
    evil
    which-key
    company

    doom-modeline
    dashboard

    ivy
    counsel
    swiper
  ]) ++ (with epkgs.melpaPackages; [
    lsp-mode
    lsp-ui
    racket-mode
    spacemacs-theme
    vterm

    all-the-icons-dired
    all-the-icons
  ]) ++ (with epkgs.elpaPackages; [ 
  ]) ++ (with pkgs; [
    # Other maybe useful stuff
    racket
    nodejs
    nixfmt
    hy

    # Emacs LSP
    nodePackages.pyright
    nodePackages.eslint
    ccls
    rnix-lsp

    emacs-all-the-icons-fonts
  ]));

  emacs = ((pkgs.emacsPackagesFor myEmacs).emacsWithPackages emacs-packages);
}


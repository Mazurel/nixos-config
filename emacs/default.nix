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

    all-the-icons
    doom-modeline

    ivy
    counsel
    swiper
  ]) ++ (with epkgs.melpaPackages; [
    lsp-mode
    ccls
  ]) ++ (with epkgs.elpaPackages; [ 
  ]));

  emacs = ((pkgs.emacsPackagesFor myEmacs).emacsWithPackages emacs-packages);
}


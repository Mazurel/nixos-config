{ lib, config, pkgs, ... }:
with lib;
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mateusz";
  home.homeDirectory = "/home/mateusz";

  home.packages = with pkgs; [
    bat
    ripgrep
  ];

  programs.neovim = import ./nvim { lib=lib; pkgs=pkgs; };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      theme = "aussiegeek";
    };
  };

  programs.git = {
    enable = true;
    userName = "Mazurel";
    userEmail = "mateusz.mazur@yahoo.com";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}

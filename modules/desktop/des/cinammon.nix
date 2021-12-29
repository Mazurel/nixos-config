{ pkgs, config, lib, ... }:
let cfg = config.mazurel.xorg.des.cinnamon;
in {
  options.mazurel.xorg.des.cinnamon.enable =
    lib.mkEnableOption "Enable my default cinammon config";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.cinnamon.enable = true;
      displayManager.lightdm.enable = true;
    };
    services.cinnamon.apps.enable = true;

    environment.systemPackages = with pkgs; [
      alacritty
      flameshot
    ];
  };
}

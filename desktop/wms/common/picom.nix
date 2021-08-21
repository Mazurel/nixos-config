# My usual picom config
{ lib, pkgs, config, ... }:
let cfg = config.mazurel.xorg.wms.common.picom;
in {
  options.mazurel.xorg.wms.common.picom.enable =
    lib.mkEnableOption "Enable my default picom config";

  config = lib.mkIf cfg.enable {
    services.picom = {
      enable = true;
      fade = true;
      opacityRules = [
        "97:class_g = 'Alacritty' && focused"
        "95:class_g = 'Alacritty' && !focused"
        "97:class_g = 'Emacs' && focused"
        "95:class_g = 'Emacs' && !focused"
      ];
      experimentalBackends = true;
      shadow = true;
      backend = "glx";
      fadeDelta = 5;
      settings = {
        no-dock-shadow = true;
        detect-rounded-corners = true;
        use-ewmh-active-win = true;
      };
    };
  };
}

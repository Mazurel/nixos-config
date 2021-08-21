# My usual picom config
{ lib, pkgs, config, ... }:
let cfg = config.mazurel.xorg.wms.common.xautolock;
in {
  options.mazurel.xorg.wms.common.xautolock.enable =
    lib.mkEnableOption "Enable my default autolock for wms";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      xautolock = {
        enable = true;
        time = 30; # in minutes
        locker = "${pkgs.mazurel-scripts}/bin/locker";

        killtime = 60;
        killer = "/run/current-system/systemd/bin/systemctl suspend";
      };
    };
  };
}


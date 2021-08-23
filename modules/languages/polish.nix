{ pkgs, lib, config, ... }:
let cfg = config.mazurel.languages.polish;
in {
  options.mazurel.languages.polish.enable =
    lib.mkEnableOption "Enable useful polish related settings";

  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Warsaw";
    location.provider = "geoclue2";

    i18n.defaultLocale = "pl_PL.UTF-8";

    console = {
      font = "Lat2-Terminus16";
      keyMap = "pl";
    };

    services.xserver.layout = "pl";
  };
}

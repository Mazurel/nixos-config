{ pkgs, config, lib, ... }:
with pkgs;
let
  cfg = config.mazurel.anbox;

in
{
  options.mazurel.anbox = {
    enable = lib.mkEnableOption "Enable my anbox settings";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.anbox.enable = false;
  };
}

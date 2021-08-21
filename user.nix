# This file makes it easier for my settings to set home-manager related stuff.
#
# It is using a simple trick so that my modules can access home-manager
# settings via `config.mazurel.home-manager` attribute.
# 
{ pkgs, config, lib, ... }:
let cfg = config.mazurel;
in {
  options.mazurel.username = lib.mkOption {
    type = lib.types.str;
    default = "mateusz";
    description = ''
      This is the name for main user (other then root).
      All home-manager related settings will be set for this user.
    '';
  };

  options.mazurel.home-manager = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    description = ''
      These are home-manager settings that will be applied to the user.
      This is for pure convinience and modularity.
    '';
  };

  config.home-manager = {
    users.${cfg.username} = (import ./home-manager) cfg.home-manager;

    # It is required for this trick to work
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}

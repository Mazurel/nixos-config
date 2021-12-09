{ nixos }:
{ pkgs, config, lib, ...  }: {
  options.mazurel.programs = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    example = [ pkgs.nvim ];
    default = [];
    description = ''
    List of packages to be installed globally on NixOS or locally when using home manager without NixOS
    '';
  };
  options.mazurel.nixos = lib.mkOption {
    type = lib.types.any;
    default = {};
    description = ''
    Whole nixos confiuration.
    '';
  };

  # TODO: Fix this thing
  #config = if nixos then
  #  (lib.attrsets.recursiveUpdate {
  #  environment.systemPackages = config.mazurel.programs;
  #  } config.mazurel.nixos) else ({
  #  # Rest of the home-manager inheritance is in ./user.nix
  #  mazurel.home-manager.packages = config.mazurel.programs;
  #});
}

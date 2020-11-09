# All filesystem mounts, that are not defined in hardware_config
{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems = {
    "/home" =
    { 
      device = "/dev/disk/by-uuid/20ab98a9-6ab5-4d10-a631-c9332d697154";
      fsType = "ext4";
    };
    "/mnt/vms" =
    { 
      device = "/dev/disk/by-uuid/06c6e551-10a6-41cc-b570-28f858752535";
      fsType = "ext4";
    };
    "/mnt/data" =
    { 
      device = "/dev/disk/by-uuid/5011fc86-9840-496d-a474-a5fcefec9d19";
      fsType = "ext4";
    };
  };
}

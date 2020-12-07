{ pkgs, ... }:
{
# Use the GRUB 2 boot loader.
  boot.loader = {
    grub = {
      enable = true;
      version = 2;

      # Efi config
      efiSupport = true;
      efiInstallAsRemovable = false;
      device = "nodev";

      # Specific for device
      extraEntries = ''
        menuentry "Arch" {
        search --set=arch --fs-uuid 7ede759b-7d19-4c66-b98d-e8d7b7497dc0
        configfile "($arch)/boot/grub/grub.cfg"
        }
      '';
    };

    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
  };
}

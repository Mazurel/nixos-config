# This is settings file that is specific to my PC machine
#
# It is propagated into nixos configuration
{ pkgs, lib, modulesPath, config, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  mazurel.username = "mateusz";
  mazurel.languages.polish.enable = true;

  # mazurel.wayland.wms.sway.enable = true;
  mazurel.xorg.des.gnome.enable = true;

  # services.flatpak.enable = lib.mkForce false;
  # xdg.portal.enable = lib.mkForce false;

  mazurel.development.emacs.enable = true;
  mazurel.development.emacs.defaultEditor = true;

  mazurel.anbox.enable = true;
  mazurel.virtualization = {
    enable = true;
    # Devices that will be disabled and ready for passthorugh
    # Remember to disable gpu in bios (change display)
    passthrough = {
      enable = false;
      # Ids can be read from `lspci -nnk`
      gpu = {
        enable = true;
        ids1 = [ "0000:01:00.0" "0000:01:00.1" ];
        ids2 = [ "1002:67df" "1002:aaf0" ];
      };
      audio-card = {
        enable = false;
        ids1 = [ "0000:00:1b.0" ];
        ids2 = [ "8086:8c20" ];
      };
    };

    # Needed if acs are not valid
    acs-override-patch = false;
  };

  # Looking glass
  environment.etc."tmpfiles.d/10-looking-glass.conf".text =
    let
      user =
        if config.virtualisation.libvirtd.qemuRunAsRoot
        then "root"
        else "qemu-libvirtd";
    in
    ''
      # Type Path              Mode UID     GID Age Argument

      f /dev/shm/looking-glass 0660 ${user} kvm -
    '';

  nix.maxJobs = 8;

  # Network settings
  networking = {
    hostName = "Nixos-desktop";

    networkmanager.enable = true;

    interfaces = {
      # Specific for device
      eno1.useDHCP = true;
    };
    wireless.enable = false; # Enables wpa_supplicant
  };

  services.xserver.videoDrivers = [ "intel" "nvidia" "amdgpu" ];
  hardware.nvidia.modesetting.enable = true;

  mazurel.development.cuda.enable = false;

  virtualisation.docker.enable = true;

  # hardware.opengl.enable = true;
  # hardware.opengl.extraPackages = [ pkgs.rocm-opencl-icd ];
  
  # Make CPU speed as fast as possible
  powerManagement.cpuFreqGovernor = "performance";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  # boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

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

        menuentry "UEFI Settings" {
        fwsetup
        }
      '';
    };

    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NixStore";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/Home";
    fsType = "ext4";
  };

  fileSystems."/mnt/vms" = {
    device = "/dev/disk/by-label/Vms";
    fsType = "ext4";
  };

  # I think by disk is dead
  #  fileSystems."/mnt/data" = {
  #    device = "/dev/disk/by-label/LinuxData";
  #    fsType = "ext4";
  #  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/5c9a0638-aedf-4cad-8e64-e29632c0ed12"; }];
}

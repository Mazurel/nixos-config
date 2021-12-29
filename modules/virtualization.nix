{ pkgs, config, lib, ... }:
with pkgs;
let cfg = config.mazurel.virtualization;

in
{
  options.mazurel.virtualization = {
    enable = lib.mkEnableOption "Enable my virtualization settings";

    acs-override-patch = lib.mkEnableOption
      "Apply acs-override patch to the kernel (not needed with ZEN kernel)";

    passthrough = {
      enable = lib.mkEnableOption "Enable my virtualized passthrough settings";
      gpu = {
        enable = lib.mkEnableOption "Enable GPU passthrough";
        ids1 = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [ "0000:01:00.0" "0000:01:00.1" ];
          default = [ ];
          description = ''
            This value can be read by running: `lspci -nnk` (it is specified at the end).
            It is important to passthrough all GPU related devices.
          '';
        };
        ids2 = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [ "1002:67df" "1002:aaf0" ];
          default = [ ];
          description = ''
            This value can be read by running: `lspci -nnk` (it is specified at the begining).
            It is important to passthrough all GPU related devices.
          '';
        };
      };
      audio-card = {
        enable = lib.mkEnableOption "Enable audio card passthrough";
        ids1 = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [ "0000:01:00.0" "0000:01:00.1" ];
          default = [ ];
          description = ''
            This value can be read by running: `lspci -nnk` (it is specified at the end).
          '';
        };
        ids2 = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [ "1002:67df" "1002:aaf0" ];
          default = [ ];
          description = ''
            This value can be read by running: `lspci -nnk` (it is specified at the begining).
          '';
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf
      cfg.enable
      {
        environment.systemPackages =
          [ virt-manager ebtables dnsmasq udev OVMF pciutils kvm ];

        boot.kernelParams = [
          "intel_iommu=on"
          "pcie_aspm=off"
          "pcie_acs_override=downstream,multifunction"
        ];
        boot.kernelModules =
          [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel" ];

        boot.initrd.availableKernelModules = [ "vfio-pci" ];

        # This is needed for non zen kernel
        boot.kernelPatches = lib.optionals cfg.acs-override-patch ({
          name = "acs-override";
          patch = pkgs.fetchurl {
            url =
              "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
            sha256 = "0xrzb1klz64dnrkjdvifvi0a4xccd87h1486spvn3gjjjsvyf2xr";
          };
        });

        virtualisation.libvirtd.enable = true;
        virtualisation.libvirtd.qemu.ovmf.enable = true;
        virtualisation.libvirtd.qemu.runAsRoot = false;
      })
    (lib.mkIf cfg.passthrough.enable (
      let
        passthrough-devices = with cfg; {
          ids1 = (lib.optionals passthrough.gpu.enable passthrough.gpu.ids1)
            ++ (lib.optionals passthrough.audio-card.enable
            passthourgh.audio-card.ids1);
          ids2 = (lib.optionals passthrough.gpu.enable passthrough.gpu.ids2)
            ++ (lib.optionals passthrough.audio-card.enable
            passthrough.audio-card.ids2);
        };
      in
      {
        boot.initrd.preDeviceCommands = ''
          DEVS="${lib.concatStrings (lib.intersperse " " passthrough-devices.ids1)}"
          for DEV in $DEVS; do
            echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
          done
          modprobe -i vfio-pci
        '';

        boot.extraModprobeConfig = "options vfio-pci ids=${
          lib.concatStrings (lib.intersperse "," (passthrough-devices.ids2 ++ passthrough-devices.ids1))
      }";
      }
    ))
  ];

}

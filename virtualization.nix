settings:
{ pkgs, ... }:
with pkgs;
let
  # Devices to be passthroughed
  passthrough-devices = with settings.virtualization; {
    ids1 = lib.optionals passthrough.enable 
      (lib.optionals passthrough.gpu.enable passthrough.gpu.ids1) ++ (lib.optionals passthrough.audio-card.enable passthourgh.audio-card.ids1);
    ids2 = lib.optionals passthrough.enable
      (lib.optionals passthrough.gpu.enable passthrough.gpu.ids2) ++ (lib.optionals passthrough.audio-card.enable passthrough.audio-card.ids2);
  };
in
{
  environment.systemPackages = [
    virt-manager
    ebtables
    dnsmasq
    udev
    OVMF
    pciutils
    kvm
  ];

  boot.kernelParams = [ "intel_iommu=on" "pcie_aspm=off" "pcie_acs_override=downstream,multifunction" ];
  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel" ];

  # This is needed if I not use zen kernel
  boot.kernelPatches = lib.optionals settings.virtualization.acs-override-patch 
    ({
      name = "acs-override";
      patch = pkgs.fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
      sha256 = "0xrzb1klz64dnrkjdvifvi0a4xccd87h1486spvn3gjjjsvyf2xr";
      };
    });

  boot.initrd.availableKernelModules = [ "vfio-pci" ];
  boot.initrd.preDeviceCommands = ''
    DEVS="${lib.concatStrings (lib.intersperse " " passthrough-devices.ids1)}"
    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';

  boot.extraModprobeConfig = "options vfio-pci ids=${lib.concatStrings (lib.intersperse "," passthrough-devices.ids2)}";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;
  virtualisation.libvirtd.qemuRunAsRoot = false;
}

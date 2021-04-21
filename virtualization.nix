{ pkgs ? import <nixpkgs> {}, ... }:
with pkgs;
# Todo add support for other than nvidia and intel
# Mostly for future reference 
let 
  # Passthrough settings
  passthourgh = {
    enable = false;
    gpu = true;
    audio-card = false;
  };

  passthourgh-devices = {
    ids1 = if passthourgh.enable then
           ((lib.optionals passthourgh.gpu [ "0000:01:00.0" "0000:01:00.1" ]) ++
           (lib.optionals passthourgh.audio-card [ "0000:00:1b.0" ])) 
           else []; 
    ids2 = if passthourgh.enable then
           ((lib.optionals passthourgh.gpu [ "1002:67df" "1002:aaf0" ]) ++
           (lib.optionals passthourgh.audio-card [ "8086:8c20" ]))
           else [];
  };
in
{
  boot.kernelParams = [ "intel_iommu=on" "pcie_aspm=off" "pcie_acs_override=downstream,multifunction" ];
  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel" ];
#  boot.kernelPatches = [
#    {
#      name = "acs-override";
#      patch = pkgs.fetchurl {
#        url = "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
#        sha256 = "0xrzb1klz64dnrkjdvifvi0a4xccd87h1486spvn3gjjjsvyf2xr";
#      };
#    }
#  ];
  boot.initrd.availableKernelModules = [ "vfio-pci" ];
  boot.initrd.preDeviceCommands = ''
  DEVS="${lib.concatStrings (lib.intersperse " " passthourgh-devices.ids1)}"
  for DEV in $DEVS; do
    echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
  done
  modprobe -i vfio-pci
  '';

  boot.extraModprobeConfig = "options vfio-pci ids=${lib.concatStrings (lib.intersperse "," passthourgh-devices.ids2)}";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;
  virtualisation.libvirtd.qemuRunAsRoot = false;
}


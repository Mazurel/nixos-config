{ pkgs ? import <nixpkgs> {}, pcis ? [] }:
with pkgs;
# Todo add support for other than nvidia and intel
# Mostly for future reference 
{
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel" ];

  # 8086:0c01,10de:13c2,10de:0fbb

  boot.extraModprobeConfig = "options vfio-pci ids=${lib.fold (x : acc : acc + ",${x}") pcis}";

  boot.initrd.availableKernelModules = [ "vfio-pci" ];

  services.xserver.videoDrivers = [ "intel" ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;
  virtualisation.libvirtd.qemuRunAsRoot = false;
}


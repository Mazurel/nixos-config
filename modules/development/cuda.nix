{ pkgs, lib, config, ... }:
let cfg = config.mazurel.development.cuda;
in
{
  options.mazurel.development.cuda.enable =
    lib.mkEnableOption "Enable CUDA development suite";

  # Based on https://github.com/grahamc/nixos-cuda-example/blob/master/configuration.nix
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pciutils
      file
      gnumake
      gcc
      cudatoolkit
    ];

    services.xserver.videoDrivers = [ "nvidia" ];

    systemd.services.nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };

    nixpkgs.config.allowUnfree = true;
  };
}

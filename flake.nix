{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:
    let settings-lib = import ./settings-lib.nix;
    in {
      nixosConfigurations.pc = let
        settings = (import ./settings/pc.nix) // { lib = settings-lib; };
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = ((settings.lib settings).forAllApplySettings [
          ./configuration.nix
        ]) ++ [
          nixos-hardware.nixosModules.common-cpu-intel
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mateusz = import ./home-manager;
          }
        ];
      };
    };
}

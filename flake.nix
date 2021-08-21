{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.comma = { url = "github:Shopify/comma"; flake = false; };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, comma }:
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.common-cpu-intel
          home-manager.nixosModules.home-manager
          {
            imports = [
                ./user.nix
            ];
            
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ({ ... }: {
            nixpkgs.overlays = [ self.overlay ];
          })
        ];
      };

      overlay = final: prev: {
        mazurel-scripts = final.callPackage ./scripts { };
        comma = final.callPackage comma { };
      };
    };
}

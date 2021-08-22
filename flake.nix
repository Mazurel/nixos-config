{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.comma = {
    url = "github:Shopify/comma";
    flake = false;
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, comma }: {
    nixosModules = {
      # This module boundles modules that are required for
      # my configurations to work
      mazurel = { ... }: {
        imports = [
          ./modules/default.nix
          ./modules/user.nix
          home-manager.nixosModules.home-manager
          { }
          ({ ... }: { nixpkgs.overlays = [ self.overlay ]; })
        ];
      };
    };

    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.mazurel

          nixos-hardware.nixosModules.common-cpu-intel
          ./settings/pc.nix
        ];
      };
    };

    overlay = final: prev:
      {
        mazurel-scripts = final.callPackage ./packages/scripts { };
        comma = final.callPackage comma { };
        fluentReader = final.callPackage ./packages/fluentReader.nix { };
      } // (import ./packages/matlab/default.nix) {
        callPackage = final.callPackage;
      };
  };
}

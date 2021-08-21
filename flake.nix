{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.comma = {
    url = "github:Shopify/comma";
    flake = false;
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, comma }: {
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./settings/pc.nix
        ./modules/default.nix
        nixos-hardware.nixosModules.common-cpu-intel
        home-manager.nixosModules.home-manager
        { imports = [ ./modules/user.nix ]; }
        ({ ... }: { nixpkgs.overlays = [ self.overlay ]; })
      ];
    };

    overlay = final: prev: {
      mazurel-scripts = final.callPackage ./packages/scripts { };
      comma = final.callPackage comma { };
      fluentReader = final.callPackage ./packages/fluentReader.nix { };
    } // (import ./packages/matlab/default.nix) { callPackage = final.callPackage; };
  };
}

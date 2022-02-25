{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  # inputs.nixpkgs.url = "/home/mateusz/nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nix-matlab.url = "gitlab:doronbehar/nix-matlab";
  inputs.comma = {
    url = "github:Shopify/comma";
    flake = false;
  };
  inputs.nixos-rocm = {
    url = "github:nixos-rocm/nixos-rocm";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nix-matlab, comma, nixos-rocm }: {
    nixosModules = {
      # This module boundles modules that are required for
      # my configurations to work
      mazurel = { ... }: {
        imports = [
          ./modules/default.nix
          ./modules/user.nix
          (import ./modules/programs.nix { nixos = true; })
          home-manager.nixosModules.home-manager
          { }
          (
            { ... }: {
              nixpkgs.overlays = [ self.overlay nix-matlab.overlay nixos-rocm.overlay ];
              nix.registry.nixpkgs.flake = nixpkgs;
              # nix.registry.configuration.flake = "/etc/nixos";
            }
          )
        ];
      };
    };

    homeManagerModules = {
      # This module boundles modules that are required for
      # my configurations to work
      mazurel = { ... }: {
        imports = [
          (import ./modules/programs.nix { nixos = false; })
          home-manager.nixosModules.home-manager
          { }
          (
            { ... }: {
              nixpkgs.overlays = [ self.overlay nix-matlab.overlay ];
              nix.registry.nixpkgs.flake = nixpkgs;
              # nix.registry.configuration.flake = "/etc/nixos";
            }
          )
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

      lenovo-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.mazurel

          nixos-hardware.nixosModules.common-cpu-intel
          ./settings/lenovo-laptop.nix
        ];
      };
    };

    overlay = final: prev:
      {
        mazurel-scripts = final.callPackage ./packages/scripts { };
        comma = final.callPackage comma { };
        fluentReader = final.callPackage ./packages/fluentReader.nix { };
        inkscape-with-custom-extensions = prev.inkscape-with-extensions.override {
          inkscapeExtensions = [
            (prev.callPackage ./packages/textext.nix { })
          ];
        };
      };
  };
}

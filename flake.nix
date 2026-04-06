{
  description = "Matthew's NixOS config with hosts, modules, Home Manager, and themes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.testing-vm = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self;
          inherit USERNAME;
        };
        modules = [
          ./hosts/testing-vm
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.matthew = import ./users/matthew/home.nix;
            home-manager.extraSpecialArgs = {
              inherit self;
            };
          }
        ];
      };
    };
}

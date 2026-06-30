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

    rofi-suite = {
      url = "path:/home/matthew/code/rofi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, rofi-suite, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations.testing-vm = lib.nixosSystem {
      inherit system;
      specialArgs = { inherit self; };
      modules = [
        ./hosts/testing-vm
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix

        {
          home-manager = {
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit self rofi-suite; };
            overwriteBackup = true;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.matthew = import ./users/matthew/home.nix;
          };
        }
      ];
    };
  };
}

#stylix.base16Scheme = {
#  base00 = "1a1444";
#  base01 = "2e418d";
#  base02 = "6b58ce";
#  base03 = "73a2ce";
#  base04 = "99bce2";
#  base05 = "f7ded9";
#  base06 = "fbe8d7";
#  base07 = "f4e2ce";
#  base08 = "8386ed";
#  base09 = "b5838e";
#  base0A = "7191cc";
#  base0B = "9b89b3";
#  base0C = "7c8cd9";
#  base0D = "a786a1";
#  base0E = "a882bf";
#  base0F = "947dff";
#};
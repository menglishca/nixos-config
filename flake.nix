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
            url = "github:menglishca/rofi-suite";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, stylix, rofi-suite, ... }:
    let
        system = "x86_64-linux";
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            testing-vm = lib.nixosSystem {
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
                            users.matthew = import ./users/desktop/home.nix;
                        };
                    }
                ];
            };
            menglishca = lib.nixosSystem (
                inherit system;
                specialArgs =  { inherit self; };
                modules = [
                    ./hosts/menglishca
                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            backupFileExtension = "backup";
                            extraSpecialArgs = { inherit self rofi-suite; };
                            overwriteBackup = true;
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            users.matthew = import ./users/desktop/home.nix;
                        };
                    }
                ];
            )
        };
    };
}

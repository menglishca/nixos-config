{
  description = "Flake for Primary Desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.matthew = import ./home-manager/matthew.nix;
          home-manager.backupFileExtension = "backup";
        }

        stylix.nixosModules.stylix
        ({ config, pkgs, ... }: {
          stylix = {
            enable       = true;
            polarity     = "dark";
            base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
            autoEnable   = true;
            fonts = {
                  serif = {
                    package = pkgs.roboto-slab;
                    name    = "Roboto Slab";
                };
                sansSerif = {
                    package = pkgs.fira;
                    name    = "Fira Sans";
                };
                monospace = {
                    package = pkgs.nerd-fonts.sauce-code-pro;
                    name    = "SauceCodePro Nerd Font";
                };

                # If you want different sizes per target:
                sizes = {
                    applications = 10;
                    desktop = 9;
                    popups = 10;
                    terminal = 10;
                };
            };
          };
        })
      ];
    };
  };
}

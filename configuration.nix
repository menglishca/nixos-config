# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./program-configuration.nix
      ./boot-configuration.nix
      ./system-configuration.nix
      ./desktop-configuration.nix
      <home-manager/nixos>
    ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"  # Community pkgs (e.g., neovim plugins)
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16Zjyypy8cSk9ETrE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # Max jobs/connections for faster downloads
    cores = 0;  # Use all cores
    max-jobs = "auto";
    sandbox = true;  # Secure builds
    experimental-features = [ "nix-command" "flakes" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.matthew = import ./home-manager/matthew.nix;
  };
}

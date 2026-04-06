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
    ];
  nix.settings = {
    substituters = lib.mkForce [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = lib.mkForce [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # keep the rest if you want 
    cores = 0;
    max-jobs = "auto";
    sandbox = true;
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
}

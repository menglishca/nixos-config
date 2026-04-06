{ config, lib, pkgs, ... }:

{
  # This module contains shared operating system defaults.
  # Keep reusable system-wide behavior here rather than in a specific host.

  imports = [
    ./system/default.nix
    ../unfree.nix
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

    # Flakes are enabled here because this repo uses flake.nix as the entry point.
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = true;
    auto-optimise-store = true;
    cores = 0;
    max-jobs = "auto";
  };

  # Set this once for the machine family if everything is x86_64 Linux.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Pin this to the release you first installed from and only change it intentionally.
  system.stateVersion = lib.mkDefault "25.11";

  allowedUnfreePackages = [
    "anydesk"
    "vscode"
    "zoom"
  ];
}

{ config, lib, pkgs, ... }:

{
  # A host file should stay small.
  # Think of it as the place where you compose pieces together:
  # - hardware-specific details for this machine
  # - shared NixOS modules
  # - one selected theme/rice
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/services/ssh/desktop.nix
    ../../modules/nixos/desktop/default.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/boot/grub.nix
    ../../modules/nixos/system/env/desktop.nix
  ];

  networking.hostName = "testing-vm";

  # Put machine-only settings here.
  # Examples: laptop battery tweaks, NVIDIA settings, extra disks, monitors.
}

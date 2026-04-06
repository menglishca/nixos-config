{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot.enable = false;

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
}
{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub.enable = false;

    systemd-boot = {
      enable = true;
    };
  };
}
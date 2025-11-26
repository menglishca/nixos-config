# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./program-configuration.nix
      ./boot-configuration.nix
      ./system-configuration.nix
      ./desktop-configuration.nix
      ./themes/small-sur.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  themes.smallSur.enable = true;
}

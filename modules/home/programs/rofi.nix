# modules/home/programs/rofi.nix
{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
  };
}
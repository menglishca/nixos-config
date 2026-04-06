# modules/home/programs/firefox.nix
{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.main = {
      isDefault = true;
    };
  };
}
# modules/home/programs/alacritty.nix
{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings.font = {
      offset = {
        x = 0;
        y = -1;
      };
    };
  };
}
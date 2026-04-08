# modules/home/dotfiles.nix
{ config, lib, pkgs, mkDotfiles, ... }:

let
  globalHomeFiles = mkDotfiles {
    path = ./dotfiles;
    name = "home-dotfiles";
  };
in
{
  home.file = globalHomeFiles;
}
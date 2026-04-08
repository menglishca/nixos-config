# modules/home/dotfiles.nix
{ config, lib, pkgs, populateDotfiles, ... }:

let
  dotfilesDir = builtins.path {
    path = ./dotfiles;
    name = "home-dotfiles";
  };

  globalHomeFiles = populateDotfiles {
    inherit dotfilesDir;
    prefixDot = true;
  };
in
{
  home.file = globalHomeFiles;
}
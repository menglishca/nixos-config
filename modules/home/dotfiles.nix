# modules/home/dotfiles.nix
{ config, lib, pkgs, populateDotfiles, ... }:

let
  dotfilesDir = ./dotfiles;

  globalHomeFiles = populateDotfiles {
    inherit dotfilesDir;
    prefixDot = true;  # "bin" -> ".bin"
  };
in
{
  home.file = globalHomeFiles;
}
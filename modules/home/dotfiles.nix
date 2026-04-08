# modules/home/dotfiles.nix
{ config, lib, pkgs, ... }:

let
  dotfilesDir = ./dotfiles;

  globalHomeFiles = config.home.mkDotfilesHomeFiles {
    inherit dotfilesDir;
    prefixDot = true;  # "bin" -> ".bin"
  };
in
{
  home.file = globalHomeFiles;
}
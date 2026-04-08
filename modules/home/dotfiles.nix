# modules/home/dotfiles.nix
{ config, lib, pkgs, ... }:

let
  dotfilesDir = ./dotfiles;

  # Map e.g. "bin" -> ".bin", "config" -> ".config"
  toHomeName = name: ".${name}";

  entries = builtins.readDir dotfilesDir;

  homeFiles =
    lib.listToAttrs (map
      (name: {
        name = toHomeName name;
        value = {
          source = "${dotfilesDir}/${name}";
        };
      })
      (lib.attrNames entries));
in
{
  # copy everything under modules/home/dotfiles/* -> ~/.<name>
  home.file = homeFiles;
}
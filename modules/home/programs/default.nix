# modules/home/programs/default.nix
{ config, lib, pkgs, ... }:

let
  # All entries in this directory
  entries = builtins.readDir ./.;

  # Keep only *.nix files, excluding default.nix
  nixFiles =
    lib.attrNames
      (lib.filterAttrs
        (name: type:
          type == "regular"
          && lib.hasSuffix ".nix" name
          && name != "default.nix"
        )
        entries
      );

  # Turn ["alacritty.nix" "bash.nix" ...] into [ ./alacritty.nix ./bash.nix ... ]
  importsList = map (name: ./. + "/${name}") nixFiles;
in
{
  imports = importsList;
}
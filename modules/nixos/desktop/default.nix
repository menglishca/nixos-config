{ config, lib, pkgs, ... }:

{
  # Desktop preset entry point.
  # Hosts should import this file instead of each submodule directly.
  imports = [
    ./xfce.nix
    ./fonts.nix
  ];
}

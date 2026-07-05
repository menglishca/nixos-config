{ config, lib, pkgs, ... }:

{
  # System-level defaults that are not specific to one desktop environment.
  imports = [
    ./env
    ./ssh.nix
    ./users.nix
  ];
}
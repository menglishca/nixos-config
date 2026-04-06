{ config, lib, pkgs, ... }:

{
  # System-level defaults that are not specific to one desktop environment.
  imports = [
    ./users.nix
    ./ssh.nix
    ./env.nix
  ];
}
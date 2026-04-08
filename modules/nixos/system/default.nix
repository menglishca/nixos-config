{ config, lib, pkgs, ... }:

{
  # System-level defaults that are not specific to one desktop environment.
  imports = [
    ./env.nix
    ./ssh.nix
    ./users.nix
  ];
}
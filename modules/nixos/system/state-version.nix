{ config, lib, pkgs, ... }:

{
  # This is the compatibility version for stateful system defaults.
  # Do not bump it casually just because you upgraded nixpkgs.
  system.stateVersion = "25.05";
}
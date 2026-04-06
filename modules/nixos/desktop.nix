{ config, lib, pkgs, ... }:

{
  # Compatibility wrapper.
  # Old imports of ../../modules/nixos/desktop.nix will still work.
  imports = [
    ./desktop/default.nix
  ];
}

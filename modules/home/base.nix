# modules/home/base.nix
{ config, lib, pkgs, ... }:

{
  # Shared Home Manager defaults for all users

  # Home Manager state version (separate from NixOS).
  home.stateVersion = "25.11";

  # Enable the Home Manager program itself.
  programs.home-manager.enable = true;
}
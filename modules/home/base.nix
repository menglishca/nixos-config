{ config, lib, pkgs, ... }:

{
  # Home Manager controls user-level programs, files, and preferences.
  # Use this for shell config, Git config, editor config, and dotfiles.

  home.username = "matthew";
  home.homeDirectory = "/home/matthew";

  # Home Manager also has a stateVersion, separate from NixOS.
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}

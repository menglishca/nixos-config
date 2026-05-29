{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/programs
    ../../modules/home/xdg.nix
    ../../modules/home/theme.nix
    ../../modules/home/dotfiles.nix
    ../../modules/home/keybinds.nix
  ];

  home = {
    username = "matthew";
    homeDirectory = "/home/matthew";
    theme = "PopOS";
    themeOptions.PopOS.variant = "light";
  };
}

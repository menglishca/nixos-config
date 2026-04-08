{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/programs
    ../../modules/home/xdg.nix
    ../../modules/home/theme.nix
    ../../modules/home/dotfiles.nix
  ];

  home = {
    username = "matthew";
    homeDirectory = "/home/matthew";
    theme = "PopOS";
    themeOptions.PopOS.variant = "light";
  };

  # This file is your user-level composition root.
  # Keep it readable. It should answer:
  # - which home modules does this user want?
  # - which user-specific choices differ from other users?
}

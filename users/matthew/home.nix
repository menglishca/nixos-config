{ config, lib, pkgs, rofi-suite, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/programs
    ../../modules/home/xdg.nix
    ../../modules/home/theme.nix
    ../../modules/home/dotfiles.nix
    ../../modules/home/keybinds.nix
    rofi-suite.homeManagerModules.default
  ];

  home = {
    username = "matthew";
    homeDirectory = "/home/matthew";
    theme = "PopOS";
    themeOptions.PopOS.variant = "light";
  };

  programs.rofi-suite = {
    enable = true;
    package = rofi-suite.packages.${pkgs.stdenv.hostPlatform.system}.default;
    themeType = "rounded";
    useStylixColors = true;

    desktopThemes = {
      drun.type = "iconic";
    };
  };
}

{ config, lib, pkgs, ... }:

{
  # System-wide fonts used by the desktop.
  fonts = {
    fontconfig.enable = true;
    packages = [
      pkgs.nerd-fonts.sauce-code-pro
    ];
  };
}

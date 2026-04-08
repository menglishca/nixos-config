{ config, lib, pkgs, ... }:

{
  # XFCE + X11 + LightDM setup.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce";
    };

    desktopManager.xfce.enable = true;
  };

  # Remove XFCE apps you do not want when enabling the desktop.
  environment.xfce.excludePackages = [
    pkgs.xfce4-terminal
    pkgs.mousepad
  ];
}

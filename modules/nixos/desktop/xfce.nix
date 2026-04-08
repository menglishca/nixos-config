{ config, lib, pkgs, ... }:

{
  # XFCE + X11 + LightDM setup.
  services = {
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      displayManager.lightdm.enable = true;
    };
    displayManager = {
      defaultSession = "xfce";
    };
  };

  environment.systemPackages = with pkgs; [
    xfce4-whiskermenu-plugin
    xfce4-docklike-plugin
    xfce4-panel-profiles
    xfce4-pulseaudio-plugin
    networkmanager
  ];

  # Remove XFCE apps you do not want when enabling the desktop.
  environment.xfce.excludePackages = [
    pkgs.xfce4-terminal
    pkgs.mousepad
  ];
}

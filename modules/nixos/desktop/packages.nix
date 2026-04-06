{ config, lib, pkgs, ... }:

{
  # Desktop-wide XFCE plugins and extras.
  environment.systemPackages = with pkgs.xfce; [
    xfce4-whiskermenu-plugin
    xfce4-docklike-plugin
    xfce4-panel-profiles
    xfce4-pulseaudio-plugin
  ];
}

{ config, pkgs, lib, ... }:

{
  imports = [
    ./themes/themes.nix
  ];

  # XFCE base setup (shared across themes)
  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = lib.mkDefault true;  # Or sddm/gdm
  };

  environment.systemPackages = with pkgs.xfce; [
    # Panels/plugins (always)
    xfce4-panel
    xfce4-whiskermenu-plugin
    xfce4-docklike-plugin
    xfce4-panel-profiles
    xfce4-pulseaudio-plugin
    # Add more XFCE base...
  ];

  # Pick your rice! (Delegates everything to themes/themes.nix)
  desktop.themes = {
    enable = true;
    preset = "smallSur-light";  # ← Switch here (or override in configuration.nix)
  };
}
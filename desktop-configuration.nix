{ config, lib, pkgs, ... }:

{
  # XFCE base (slim: exclude bloat, module handles core pkgs)
  services = {
    displayManager = {
      defaultSession = "xfce";  # Ensures XFCE login
    };
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;  # Defaults: GTK greeter
      };
      desktopManager = {
        xfce.enable = true;
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.sauce-code-pro
    ];
    fontconfig.enable = true;
  };

  # Optional: XFCE extras (plugins only; core from module)
  environment = {
    systemPackages = with pkgs.xfce; [
      xfce4-whiskermenu-plugin
      xfce4-docklike-plugin
      xfce4-panel-profiles  # If needed
      xfce4-pulseaudio-plugin
    ];
    xfce.excludePackages = [
      pkgs.xfce.xfce4-terminal
      pkgs.xfce.mousepad
    ];
  };
}
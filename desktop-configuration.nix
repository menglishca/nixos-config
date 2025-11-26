{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;

    # XFCE desktop
    desktopManager.xfce.enable = true;

    # Pick a display manager (login screen).
    displayManager.lightdm.enable = true;
  };

  # Enable input handling
  services.xserver.libinput.enable = true;

  # Nice-to-have extras for XFCE
  environment.systemPackages = with pkgs; [
     xfce.xfce4-volumed-pulse
#    xfce4-whiskermenu-plugin   # better applications menu
#    xfce4-pulseaudio-plugin    # volume control in panel
#    xfce4-notifyd              # desktop notifications
#    thunar-volman              # automount USB drives
  ];

  # Optional: Bluetooth GUI integration
  services.blueman.enable = true;
}

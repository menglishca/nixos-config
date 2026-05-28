# modules/home/xfce.nix
{ config, lib, pkgs, ... }:

{
  # -----------------------------
  # XFCE General Configuration
  # Settings here apply to all themes
  # -----------------------------

  # 1. Ensure required packages are installed
  home.packages = with pkgs; [
    xfce4-screenshooter
    wmctrl
    xdotool
    rofi
  ];

  # 2. XFCE Configuration (via xfconf)
  xfconf.enable = true;
  
  xfconf.settings = {
    xfwm4 = {
      snap_to_border = true;
      snap_to_windows = true;
      snap_width = 10;
      snap_resize = true;
      
      # Focus settings
      click_to_focus = true;
      focus_new = true;
      raise_on_focus = true;
    };

    # -----------------------------
    # Keyboard Shortcuts
    # -----------------------------
    "xfce4-keyboard-shortcuts" = {
      # Screenshot
      "Print" = "xfce4-screenshooter";
      
      # App launcher (Rofi)
      "<Control>space" = "${pkgs.rofi}/bin/rofi -show drun";
      
      # Terminal
      "<Control><Alt>t" = "xdg-terminal";
      
      # Window snapping (halves)
      "<Super>Left"  = "xfwm4 --move-window-left";
      "<Super>Right" = "xfwm4 --move-window-right";
      "<Super>Up"    = "xfwm4 --move-window-up";
      "<Super>Down"  = "xfwm4 --move-window-down";
    };
  };

  # -----------------------------
  # Corner Tiling Keybinds
  # -----------------------------
  xfconf.settings."xfce4-keyboard-shortcuts" = {
    "<Super>KP7" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh top-left";
    "<Super>KP9" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh top-right";
    "<Super>KP1" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh bottom-left";
    "<Super>KP3" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh bottom-right";
  };
}
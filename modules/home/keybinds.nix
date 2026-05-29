# modules/home/xfce.nix
{ config, lib, pkgs, ... }:

{
  # -----------------------------
  # XFCE General Configuration
  # Settings here apply to all themes
  # -----------------------------

    home.packages = with pkgs; [
        xfce4-screenshooter
        wmctrl
        xdotool
        rofi
    ];
  
    xfconf = {
        enable = true;
        settings = {
            xfwm4 = {
                "general/snap_to_border" = true;
                "general/snap_to_windows" = false;
                "general/snap_width" = 10;
                "general/wrap_windows" = false;
                "general/click_to_focus" = true;
                "general/focus_new" = true;
                "general/raise_on_focus" = true;
                "general/move_opacity" = 100;
                "general/box_move" = true;
            };
            "xfce4-keyboard-shortcuts" = {
                # App launcher (Rofi)
                "xfwm4/custom/<Control>space" = "${pkgs.rofi}/bin/rofi -show drun";                
                # Window snapping (halves)
                "xfwm4/custom/<Super>Left" = "tile_left_key";
                "xfwm4/custom/<Super>Right" = "tile_right_key";
                "xfwm4/custom/<Super>Up" = "tile_up_key";
                "xfwm4/custom/<Super>Down" = "tile_down_key";
                "xfwm4/custom/<Super><Alt>Left" = "tile_up_left_key";
                "xfwm4/custom/<Super><Alt>Right" = "tile_up_right_key";
                "xfwm4/custom/<Super><Alt>Down" = "tile_down_left_key";
                "xfwm4/custom/<Super><Alt>Up" = "tile_down_right_key";
            };
        };
    };
}
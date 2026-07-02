# modules/home/xfce.nix
{ config, lib, pkgs, ... }:

{

    home.packages = with pkgs; [
        xfce4-screenshooter
        wmctrl
        xdotool
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
                "commands/custom/<Control>space" = "${config.home.homeDirectory}/.config/rofi/bin/rofi-desktop.sh drun";
                "xfwm4/custom/<Super>KP_Down" = "";
                "xfwm4/custom/<Super>KP_Right" = "";
                "xfwm4/custom/<Super>KP_Next" = "";
                "xfwm4/custom/<Super>Up" = "tile_up_key";
                "xfwm4/custom/<Super>Down" = "tile_down_key";
                "xfwm4/custom/<Super>Left" = "tile_left_key";
                "xfwm4/custom/<Super>Right" = "tile_right_key";
                "xfwm4/custom/<Super><Alt>Up" = "tile_up_left_key";
                "xfwm4/custom/<Super><Alt>Left" = "tile_down_left_key";
                "xfwm4/custom/<Super><Alt>Down" = "tile_down_right_key";
                "xfwm4/custom/<Super><Alt>Right" = "tile_up_right_key";
            };
        };
    };
}
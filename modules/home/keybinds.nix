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
                snap_to_border = true;
                snap_to_windows = true;
                snap_width = 10;
                snap_resize = true;
                
                # Focus settings
                click_to_focus = true;
                focus_new = true;
                raise_on_focus = true;
            };

            "xfce4-keyboard-shortcuts" = {
                
                # App launcher (Rofi)
                "commands/custom/<Control>space" = "${pkgs.rofi}/bin/rofi -show drun";                
                # Window snapping (halves)
                "commands/custom/<Super>Left" = "tile_left_key";
                "commands/custom/<Super>Right" = "tile_right_key";
                "commands/custom/<Super>Up" = "tile_up_key";
                "commands/custom/<Super>Down" = "tile_down_key";
                "commands/custom/<Super>KP7" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh top-left";
                "commands/custom/<Super>KP9" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh top-right";
                "commands/custom/<Super>KP1" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh bottom-left";
                "commands/custom/<Super>KP3" = "${config.home.homeDirectory}/.local/bin/tile_corner.sh bottom-right";
            };
        };
    };
}
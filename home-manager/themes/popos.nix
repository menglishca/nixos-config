{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkIf;
  themeConfig = config.home.themeOptions.PopOS;
  dockConfig = {
    id = 21;
    activeIndicatorColor = "rgb(255, 255, 255)";
    inactiveIndicatorColor = "rgb(192, 191, 188)";
  };
  mkSeparator = id: {
    "plugins/plugin-${toString id}" = "separator";
    "plugins/plugin-${toString id}/expand" = true;
    "plugins/plugin-${toString id}/style" = 0;
  };
in
{
  options.home.themeOptions.PopOS = {
    variant = mkOption {
      type = types.enum [ "dark" "light" ];
      default = "dark";
      description = "Light or dark Pop!_OS variant.";
    };
  };

  config = mkIf (config.home.theme == "PopOS") {

    ############################
    # Packages (XFCE + theming)
    ############################
    home.packages = with pkgs; [
      # XFCE extras
      xfce.xfce4-power-manager
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-notifyd
      xfce.xfce4-whiskermenu-plugin

      # Spotlight-style launcher
      rofi
      rofi-power-menu

      # Pop themes
      pop-gtk-theme
      pop-icon-theme
    ];

    ############################
    # GTK theming (Stylix-owned)
    ############################
    # Do NOT set gtk.* here; Stylix owns GTK theme, icons, cursor and gtk.css.
    # We just append our dock tweaks to Stylix' generated CSS.
    stylix.targets.gtk.extraCss = ''
      /* Docklike plugin padding tweak */
      #docklike-plugin {
        padding-bottom: 3px;
      }
    '';

    ############################
    # XFCE settings (xfconf)
    ############################
    xfconf.settings = {
      #xsettings = {
      #  "Net/ThemeName" =
      #    if themeConfig.variant == "dark"
      #    then "Pop-dark"
      #    else "Pop";
#
#        "Net/IconThemeName" = "Pop";
#
#        "Gtk/CursorThemeName" = "Pop";
#      };

 #     xfwm4 = {
 #       "general/theme" =
 #         if themeConfig.variant == "dark"
 #         then "Pop-dark"
 #         else "Pop";
 #       "general/title_font" = "Inter Bold 10";
 #       "general/button_layout" = "O|HMC";
 #     };

      xfce4-panel = {
        "panels" = [ 1 2 ];

        # Top panel
        "panels/panel-1/position"      = "p=6;x=0;y=0";
        "panels/panel-1/size"          = 28;
        "panels/panel-1/length"        = 100;
        "panels/panel-1/length-adjust" = true;
        "panels/panel-1/mode"          = 0;
        "panels/panel-1/position-locked"  = true;
        "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 ];

        "plugins/plugin-1" = "whiskermenu";
        "plugins/plugin-3" = "clock";
        "plugins/plugin-3/digital-format" = "%b %-e %i:%M %p";
        "plugins/plugin-5" = "systray";
        "plugins/plugin-6" = "power-manager-plugin";
        "plugins/plugin-7" = "launcher";
        "plugins/plugin-7/items" = [ "pop-quick-menu.desktop" ];

        # Bottom panel (dock)
        "panels/panel-2/position"      = "p=10;x=0;y=0";
        "panels/panel-2/size"          = 46;
        "panels/panel-2/length"        = 100;
        "panels/panel-2/length-adjust" = true;
        "panels/panel-2/mode"          = 0;
        "panels/panel-2/position-locked"  = true;
        "panels/panel-2/autohide-behavior" = 0;

        "panels/panel-2/plugin-ids" = [ 20 dockConfig.id 22 ];
        "plugins/plugin-${toString dockConfig.id}" = "docklike";
      }
      // mkSeparator 2
      // mkSeparator 4
      // mkSeparator 20
      // mkSeparator 22;
    };

    ############################
    # Docklike plugin config
    ############################
    home.file.".config/xfce4/panel/docklike-${toString dockConfig.id}.rc".source =
      pkgs.writeText "docklike-${toString dockConfig.id}.rc" ''
        [user]
        indicatorStyle=4
        inactiveIndicatorStyle=4
        indicatorOrientation=1
        indicatorColor=${dockConfig.activeIndicatorColor}
        inactiveColor=${dockConfig.inactiveIndicatorColor}
        pinned=firefox;
        onlyDisplayVisible=true
        forceIconSize=true
        iconSize=32
      '';

    ############################
    # Pop-style quick menu
    ############################
        home.file.".local/bin/pop-quick-menu" = {
      text = ''
        #!/usr/bin/env bash
        choice=$(printf '%s\n' \
          "  Sound" \
          "  Bluetooth" \
          "  Night Light" \
          "  Settings" \
          "⏻  Power…" \
          | rofi -dmenu -p "Quick Settings")

        case "$choice" in
          "  Sound")
            pavucontrol >/dev/null 2>&1 & ;;
          "  Bluetooth")
            rofi-bluetooth >/dev/null 2>&1 & ;;
          "  Night Light")
            pkill -x redshift || redshift -O 4500K >/dev/null 2>&1 & ;;
          "  Settings")
            xfce4-settings-manager >/dev/null 2>&1 & ;;
          "⏻  Power…")
            rofi -show power-menu -modi power-menu:rofi-power-menu ;;
        esac
      '';
      executable = true;
    };

    home.file.".local/share/applications/pop-quick-menu.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Quick Settings
      Comment=PopOS-style quick settings menu
      Exec=/home/matthew/.local/bin/pop-quick-menu
      Icon=preferences-system
      Terminal=false
    '';

    ############################
    # Wallpapers
    ############################
    home.file."Pictures/Wallpapers/PopOS".source =
      pkgs.fetchFromGitHub {
        owner = "pop-os";
        repo = "gtk-theme";
        rev = "master";
        hash = "sha256-MBcbrcZlFANWvw4W8kDn+C99c0xp7FXnM/BlB5C3sAw=";
      } + "/wallpapers";
  };
}

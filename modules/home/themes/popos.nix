# modules/home/themes/popos.nix
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkIf;

  themeConfig = config.home.themeOptions.PopOS;

  dockConfig = {
    id = 21;
    activeIndicatorColor   = "rgb(255, 255, 255)";
    inactiveIndicatorColor = "rgb(192, 191, 188)";
  };

  mkSeparator = id: {
    "plugins/plugin-${toString id}" = "separator";
    "plugins/plugin-${toString id}/expand" = true;
    "plugins/plugin-${toString id}/style" = 0;
  };
  hexToRgbaList = hex: alpha:
    let
      h   = lib.removePrefix "#" hex;
      rHex = builtins.substring 0 2 h;
      gHex = builtins.substring 2 2 h;
      bHex = builtins.substring 4 2 h;

      toFloat = v: (builtins.fromTOML "x = 0x${v}").x / 255.0;
    in [
      (toFloat rHex)
      (toFloat gHex)
      (toFloat bHex)
      alpha
    ];
in
{
  # Per-theme options under home.themeOptions.PopOS
  options.home.themeOptions.PopOS = {
    variant = mkOption {
      type = types.enum [ "dark" "light" ];
      default = "dark";
      description = "Light or dark Pop!_OS variant.";
    };
  };

  # Only apply when this theme is selected
  config = mkIf (config.home.theme == "PopOS") {

    ############################
    # Stylix as plumbing, PopOS as source of truth
    ############################

    home.file."pictures/current-wallpaper.jpg".source = ../wallpapers/brain.jpg;
    # Choose wallpaper, polarity, and base16 scheme here.
    stylix = {
      image = ../wallpapers/brain.jpg;

      polarity =
        if themeConfig.variant == "dark" then "dark" else "light";

      # Example base16 scheme – replace with a real PopOS-like scheme
      base16Scheme = {
        base00 = "1a1444";
        base01 = "2e418d";
        base02 = "6b58ce";
        base03 = "73a2ce";
        base04 = "99bce2";
        base05 = "f7ded9";
        base06 = "fbe8d7";
        base07 = "f4e2ce";
        base08 = "8386ed";
        base09 = "b5838e";
        base0A = "7191cc";
        base0B = "9b89b3";
        base0C = "7c8cd9";
        base0D = "a786a1";
        base0E = "a882bf";
        base0F = "947dff";
      };

      fonts = {
        sizes = {
          applications = 10;  # GTK apps, window titles (if using GTK theme)
          terminal     = 11;  # Alacritty etc.
          desktop      = 10;  # panel, menus
        };
      };

      # Let PopOS decide which targets Stylix themes
      targets = {
        gtk.enable      = true;
        gnome.enable    = false;
        alacritty.enable = true;
        firefox = {
          enable       = true;
          profileNames = [ "main" ];
        };
        rofi = {
          enable  = true;
          fonts.enable   = true;
          opacity.enable = true;
        };
        vscode.enable = true;
      };

      # Extra GTK CSS for the dock
      targets.gtk.extraCss = ''
        /* Docklike plugin padding tweak */
        #docklike-plugin {
          padding-bottom: 3px;
        }
      '';
    };

    ############################
    # Packages (XFCE + theming)
    ############################
    home.packages = with pkgs; [
      xfce.xfce4-power-manager
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-notifyd
      xfce.xfce4-whiskermenu-plugin

      rofi
      rofi-power-menu

      pop-gtk-theme
      pop-icon-theme
    ];

    ############################
    # XFCE panel config (unchanged logic)
    ############################
    xfconf.settings = {
      xfce4-desktop = {
        "backdrop/single-image-mode" = true;
        "backdrop/single-workspace-mode" = true;
        "backdrop/screen0/monitor0/workspace0/last-image" = "${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
        "backdrop/screen0/monitorVirtual-1/workspace0/last-image" = "${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
      };
      xfce4-panel = {
        "panels" = [ 1 2 ];

        # Top panel
        "panels/panel-1/position"      = "p=6;x=0;y=0";
        "panels/panel-1/size"          = 28;
        "panels/panel-1/length"        = 100;
        "panels/panel-1/length-adjust" = true;
        "panels/panel-1/mode"          = 0;
        "panels/panel-1/position-locked"  = true;
        "panels/panel-1/background-style" = 1;
        "panels/panel-1/background-rgba"  = hexToRgba "#33302f" 1.0;
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
        "panels/panel-2/background-style" = 1;
        "panels/panel-2/background-rgba"  = hexToRgba "#33302f" 1.0;

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
  };
}
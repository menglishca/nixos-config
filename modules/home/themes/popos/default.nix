# modules/home/themes/popos.nix
{ config, lib, pkgs, mkDotfiles, ... }:

let
  inherit (lib) mkOption types mkIf;

  themeConfig = config.home.themeOptions.PopOS;
  themeHomeFiles = mkDotfiles {
    path = ./dotfiles;
    name = "popos-dotfiles";
  };

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

  genmonPanelEntry =
    { id, arg }:
    let
      base = "plugins/plugin-${toString id}";
    in {
      "${base}" = "genmon";
      "${base}/command" = "/home/matthew/.local/bin/status_icons/get_icon.sh ${arg}";
      "${base}/update-period" = 300000;
      "${base}/use-label" = false;
      "${base}/font" = "SauceCodePro Nerd Font 11";
      "${base}/use-markup" = true;
      "${base}/onclick" = "/home/matthew/.local/bin/menus/get_menu.sh ${arg}";
    };

  hexToRgba = hex: alpha:
    let
      h    = lib.removePrefix "#" hex;
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

    home.file = themeHomeFiles // {
      ".config/xfce4/panel/docklike-${toString dockConfig.id}.rc".source =
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
      "pictures/current-wallpaper.jpg".source = ../../wallpapers/brain.jpg;
    };

    ############################
    # Stylix as plumbing, PopOS as source of truth
    ############################
    stylix = {
      image = ../../wallpapers/brain.jpg;

      polarity = if themeConfig.variant == "dark" then "dark" else "light";

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
          applications = 10;
          terminal     = 11;
          desktop      = 10;
        };
      };

      targets = {
        gtk.enable       = true;
        gnome.enable     = false;
        alacritty.enable = true;
        firefox = {
          enable       = true;
          profileNames = [ "main" ];
        };
        rofi = {
          enable        = true;
          fonts.enable  = true;
          opacity.enable = true;
        };
        vscode.enable = true;
      };

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
      xfce4-genmon-plugin
      xfce4-docklike-plugin
      xfce4-power-manager
      xfce4-pulseaudio-plugin
      xfce4-notifyd
      xfce4-whiskermenu-plugin

      fira-sans

      rofi
      rofi-power-menu

      pop-gtk-theme
      pop-icon-theme

      upower
      networkmanager
      pamixer
    ];

    ############################
    # XFCE panel config
    ############################
    xfconf.enable = true;
    xfconf.settings = {
      xfce4-desktop = {
        "backdrop/single-image-mode" = true;
        "backdrop/single-workspace-mode" = true;
        "backdrop/screen0/monitor0/workspace0/last-image" =
          "${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
        "backdrop/screen0/monitorVirtual-1/workspace0/last-image" =
          "${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
      };

      xfce4-panel =
        let
          # Helper to build a separator once
          mkSep = id: mkSeparator id;
        in
        {
          # Panel IDs: 1 = left top, 2 = center top, 3 = right top, 4 = bottom dock
          "panels" = [ 1 2 3 4 ];

          ########################
          # Top-left panel (apps)
          ########################
          "panels/panel-1/position"         = "p=6;x=0;y=0";
          "panels/panel-1/size"             = 28;
          "panels/panel-1/length"           = 40;   # left 40%
          "panels/panel-1/length-adjust"    = false;
          "panels/panel-1/mode"             = 0;
          "panels/panel-1/position-locked"  = true;
          "panels/panel-1/background-style" = 1;
          "panels/panel-1/background-rgba"  = hexToRgba "#33302f" 0.5;

          # e.g. whisker + maybe a launcher
          "panels/panel-1/plugin-ids" = [ 1 2 ];
          "plugins/plugin-1" = "whiskermenu";
          # optional separator on the right edge to push into center panel visually
          "plugins/plugin-2" = "separator";

          ########################
          # Top-center panel (clock)
          ########################
          "panels/panel-2/position"         = "p=6;x=50;y=0";  # anchored center top
          "panels/panel-2/size"             = 28;
          "panels/panel-2/length"           = 20;   # narrow center strip
          "panels/panel-2/length-adjust"    = false;
          "panels/panel-2/mode"             = 0;
          "panels/panel-2/position-locked"  = true;
          "panels/panel-2/background-style" = 1;
          "panels/panel-2/background-rgba"  = hexToRgba "#33302f" 0.5;

          # separators (left/right) + clock in middle
          "panels/panel-2/plugin-ids" = [ 3 4 5 ];
          "plugins/plugin-3" = "separator";
          "plugins/plugin-3/expand" = true;
          "plugins/plugin-3/style"  = 0;

          "plugins/plugin-4" = "clock";
          "plugins/plugin-4/style" = 0;
          "plugins/plugin-4/digital-time-format" =
            "<span font_family=\"Fira Sans\" font_weight=\"bold\" size=\"9000\">%b %-e %-I:%M %p</span>";

          "plugins/plugin-5" = "separator";
          "plugins/plugin-5/expand" = true;
          "plugins/plugin-5/style"  = 0;

          ########################
          # Top-right panel (status)
          ########################
          "panels/panel-3/position"         = "p=6;x=100;y=0";
          "panels/panel-3/size"             = 28;
          "panels/panel-3/length"           = 40;   # right 40%
          "panels/panel-3/length-adjust"    = false;
          "panels/panel-3/mode"             = 0;
          "panels/panel-3/position-locked"  = true;
          "panels/panel-3/background-style" = 1;
          "panels/panel-3/background-rgba"  = hexToRgba "#33302f" 0.5;

          # left separator, then genmon icons, tray, power, quick menu
          "panels/panel-3/plugin-ids" = [ 6 7 8 9 10 11 12 ];

          "plugins/plugin-6" = "separator";
          "plugins/plugin-6/expand" = true;
          "plugins/plugin-6/style"  = 0;

          # genmon icons
          # battery / wifi / sound / power
          # (reuse your helper)
        }
        # genmon entries for plugins 7–10
        // genmonPanelEntry { id = 7;  arg = "battery"; }
        // genmonPanelEntry { id = 8;  arg = "wifi"; }
        // genmonPanelEntry { id = 9;  arg = "sound"; }
        // genmonPanelEntry { id = 10; arg = "power"; }
        // {
          # systray + power-manager + quick menu
          "plugins/plugin-11" = "systray";
          "plugins/plugin-12" = "power-manager-plugin";
          "plugins/plugin-13" = "launcher";
          "plugins/plugin-13/items" = [ "pop-quick-menu.desktop" ];
        }
        #
        ########################
        # Bottom dock on panel-4
        ########################
        // {
          "panels/panel-4/position"        = "p=10;x=0;y=0";
          "panels/panel-4/size"            = 46;
          "panels/panel-4/length"          = 100;
          "panels/panel-4/length-adjust"   = true;
          "panels/panel-4/mode"            = 0;
          "panels/panel-4/position-locked" = true;
          "panels/panel-4/autohide-behavior" = 0;
          "panels/panel-4/background-style"  = 1;
          "panels/panel-4/background-rgba"   = hexToRgba "#33302f" 0.5;

          "panels/panel-4/plugin-ids" = [ 20 dockConfig.id 22 ];
          "plugins/plugin-${toString dockConfig.id}" = "docklike";
        }
        # bottom separators reused
        // mkSeparator 20
        // mkSeparator 22;
    };
  };
}
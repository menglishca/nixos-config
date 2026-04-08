# modules/home/themes/popos.nix
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkIf;

  themeConfig = config.home.themeOptions.PopOS;
  themeDotfilesDir = ./dotfiles;
  themeHomeFiles = config.home.mkDotfilesHomeFiles {
    dotfilesDir = themeDotfilesDir;
    prefixDot   = true;
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
  hexToRgba = hex: alpha:
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
        "panels/panel-1/background-rgba"  = hexToRgba "#33302f" 0.5;
        "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 ];

        "plugins/plugin-1" = "whiskermenu";
        "plugins/plugin-3" = "clock";
        "plugins/plugin-3/digital-time-format" = "<span font_family=\"Fira Sans\" font_weight=\"bold\" size=\"9000\">%b %-e %-I:%M %p</span>";

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
        "panels/panel-2/background-rgba"  = hexToRgba "#33302f" 0.5;

        "panels/panel-2/plugin-ids" = [ 20 dockConfig.id 22 ];
        "plugins/plugin-${toString dockConfig.id}" = "docklike";
      }
      // mkSeparator 2
      // mkSeparator 4
      // mkSeparator 20
      // mkSeparator 22;
    };
  };
}
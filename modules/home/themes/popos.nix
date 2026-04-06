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
      xfce4-panel = {
        "panels" = [ 1 2 ];
        # ... keep your existing panel/dock settings here ...
      }
      // mkSeparator 2
      // mkSeparator 4
      // mkSeparator 20
      // mkSeparator dockConfig.id;
    };

    # Docklike plugin config file, quick menu, wallpapers, etc.
    # (copy over from your existing popos.nix as-is)
  };
}
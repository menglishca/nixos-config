# modules/home/themes/popos.nix
{ config, lib, pkgs, mkDotfiles, ... }:

let
  inherit (lib) mkOption types mkIf;

  themeConfig = config.home.themeOptions.PopOS;
  themeHomeFiles = mkDotfiles {
    path = ./dotfiles;
    name = "popos-dotfiles";
  };

  plugins = {
    dock = 1;
    menu = 2;
    battery = 3;
    wifi = 4;
    sound = 5;
    power = 6;
    topPanelSeparator = 7;
    bottomLeftSeparator = 8;
    bottomRightSeparator = 9;
    clockPanelLeftSeparator = 10;
    clockPanelRightSeparator = 11;
    clock = 12;
  };

  panels = {
    topClockPanel = 1;
    topSystemPanel = 2;
    bottomAppsPanel = 3;
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
      ".config/xfce4/panel/docklike-${toString plugins.dock}.rc".source =
        pkgs.writeText "docklike-${toString plugins.dock}.rc" ''
          [user]
          indicatorStyle=4
          inactiveIndicatorStyle=4
          indicatorOrientation=1
          indicatorColor="rgb(255, 255, 255)"
          inactiveColor="rgb(192, 191, 188)"
          pinned=firefox;
          onlyDisplayVisible=true
          forceIconSize=true
          iconSize=32
        '';
      "pictures/current-wallpaper.jpg".source = ../../wallpapers/brain.jpg;
      ".local/share/applications/alacritty-custom.desktop".text = ''
        [Desktop Entry]
        Name=Alacritty Custom
        Exec=${pkgs.alacritty}/bin/alacritty
        Icon=terminal
        Type=Application
        Terminal=false
        Categories=System;TerminalEmulator;
        MimeType=text/plain;
        StartupNotify=false
      '';
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Oranchelo-Beka";
      };
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

      oranchelo-icon-theme
      upower
      networkmanager
      pamixer

      # pop-gtk-theme
      # qogir-icon-theme
      # zafiro-icons
      # tela-icon-theme
      # tela-circle-icon-theme
      # papirus-icon-theme
      # fluent-icon-theme
      # papirus-folders

      # marwaita-icons
      # material-icons
      # mint-y-icons
      # cosmic-icons
      # mint-x-icons
      # mint-l-icons
      # nixos-icons
      # candy-icons
      # linearicons-free
      # faba-icon-theme
      # moka-icon-theme
      # kora-icon-theme
      # mate-icon-theme
      # tango-icon-theme
      # vimix-icon-theme
      # nordzy-icon-theme
      # colloid-icon-theme
      # dracula-icon-theme
      # kanagawa-icon-theme
      # reversal-icon-theme
      # whitesur-icon-theme
      # humanity-icon-theme
      # rose-pine-icon-theme
      # morewaita-icon-theme
      # flat-remix-icon-theme
      # beauty-line-icon-theme
      # papirus-maia-icon-theme
      # la-capitaine-icon-theme
    ];

    ############################
    # XFCE panel config
    ############################
    xfconf.enable = true;
    xfconf.settings = {
      xsettings = {
        "Net/IconThemeName" = "Oranchelo-Beka";
        "Net/ThemeName" = if themeConfig.variant == "dark" then "adw-gtk3-dark" else "adw-gtk3";
      };
      xfce4-desktop = {
        "backdrop/single-image-mode" = true;
        "backdrop/single-workspace-mode" = true;
        "backdrop/screen0/monitor0/workspace0/last-image" = "${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
        "backdrop/screen0/monitorVirtual-1/workspace0/last-image" = "${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
      };

      xfce4-panel =
        {
          "panels" = [ panels.topClockPanel panels.topSystemPanel panels.bottomAppsPanel ];

          "panels/panel-${toString panels.topClockPanel}/position" = "p=6;x=0;y=0";
          "panels/panel-${toString panels.topClockPanel}/size" = 28;
          "panels/panel-${toString panels.topClockPanel}/length" = 100;
          "panels/panel-${toString panels.topClockPanel}/length-adjust"    = true;
          "panels/panel-${toString panels.topClockPanel}/position-locked"  = true;
          "panels/panel-${toString panels.topClockPanel}/autohide-behavior" = 0;
          "panels/panel-${toString panels.topClockPanel}/mode"              = 0;
          "panels/panel-${toString panels.topClockPanel}/background-style" = 1;
          "panels/panel-${toString panels.topClockPanel}/background-rgba"  = hexToRgba "#33302f" 0.5;
          "panels/panel-${toString panels.topClockPanel}/plugin-ids"       = [ plugins.clockPanelLeftSeparator plugins.clock plugins.clockPanelRightSeparator ];

          # Top panel
          "panels/panel-${toString panels.topSystemPanel}/position"         = "p=6;x=0;y=0";
          "panels/panel-${toString panels.topSystemPanel}/size"             = 28;
          "panels/panel-${toString panels.topSystemPanel}/length"           = 100;
          "panels/panel-${toString panels.topSystemPanel}/length-adjust"    = true;
          "panels/panel-${toString panels.topSystemPanel}/mode"             = 0;
          "panels/panel-${toString panels.topSystemPanel}/position-locked"  = true;
          "panels/panel-${toString panels.topSystemPanel}/background-style" = 1;
          "panels/panel-${toString panels.topSystemPanel}/background-rgba"  = hexToRgba "#33302f" 0;
          "panels/panel-${toString panels.topSystemPanel}/plugin-ids"       = [ plugins.menu plugins.topPanelSeparator plugins.battery plugins.wifi plugins.sound plugins.power ];

          "panels/panel-${toString panels.bottomAppsPanel}/position"        = "p=10;x=0;y=0";
          "panels/panel-${toString panels.bottomAppsPanel}/size"            = 46;
          "panels/panel-${toString panels.bottomAppsPanel}/length"          = 100;
          "panels/panel-${toString panels.bottomAppsPanel}/length-adjust"   = true;
          "panels/panel-${toString panels.bottomAppsPanel}/mode"            = 0;
          "panels/panel-${toString panels.bottomAppsPanel}/position-locked" = true;
          "panels/panel-${toString panels.bottomAppsPanel}/autohide-behavior" = 0;
          "panels/panel-${toString panels.bottomAppsPanel}/background-style"  = 1;
          "panels/panel-${toString panels.bottomAppsPanel}/background-rgba"   = hexToRgba "#33302f" 0.5;
          "panels/panel-${toString panels.bottomAppsPanel}/plugin-ids" = [ plugins.bottomLeftSeparator plugins.dock plugins.bottomRightSeparator ];

          "plugins/plugin-${toString plugins.menu}" = "whiskermenu";
          "plugins/plugin-${toString plugins.menu}/show-button-title" = false;
          "plugins/plugin-${toString plugins.menu}/button-icon" = "ubuntuone-client-offline";
          "plugins/plugin-${toString plugins.clock}" = "clock";
          "plugins/plugin-${toString plugins.clock}/style" = 0;
          "plugins/plugin-${toString plugins.clock}/digital-layout" = 3;
          "plugins/plugin-${toString plugins.clock}/digital-time-format" = "<span font_family=\"Fira Sans\" font_weight=\"bold\" size=\"9000\">%b %-e %-I:%M %p</span>";
          "plugins/plugin-${toString plugins.dock}" = "docklike";
        }
        # Separators
        // mkSeparator plugins.bottomLeftSeparator
        // mkSeparator plugins.bottomRightSeparator
        // mkSeparator plugins.topPanelSeparator
        // mkSeparator plugins.clockPanelLeftSeparator
        // mkSeparator plugins.clockPanelRightSeparator
        # Genmon icons
        // genmonPanelEntry { id = plugins.battery;  arg = "battery"; }
        // genmonPanelEntry { id = plugins.wifi;  arg = "wifi"; }
        // genmonPanelEntry { id = plugins.sound; arg = "sound"; }
        // genmonPanelEntry { id = plugins.power; arg = "power"; };
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
        gtk.enable = true;
        gnome.enable = false;
        alacritty.enable = true;
        alacritty.opacity.enable = true;
        alacritty.opacity.override.terminal = 0.8;
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
        xfce.enable = true;
      };
    };
  };
}
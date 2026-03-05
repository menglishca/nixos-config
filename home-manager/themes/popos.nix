{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.home.themeOptions.PopOS;
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

      # Spotlight-style launcher (Pop Launcher or fallback) [web:59]
      # pop-launcher or ulauncher / rofi if you prefer
      rofi

      # Pop themes [web:55][web:60][web:68]
      pop-gtk-theme
      pop-icon-theme
    ];

    ############################
    # GTK theming
    ############################
    gtk = {
      enable = true;

      theme = {
        # Pop generally uses a single name "Pop" or "Pop-dark" depending on nixpkgs version; adjust if needed. [web:55][web:68]
        name =
          if cfg.variant == "dark"
          then "Pop-dark"
          else "Pop";
        package = pkgs.pop-gtk-theme;
      };

      iconTheme = {
        name = "Pop";          # pop-icon-theme installs icons under this name in most setups. [web:60][web:63]
        package = pkgs.pop-icon-theme;
      };

      cursorTheme = {
        # Pop doesn’t ship a separate cursor theme via nixpkgs in all channels,
        # so we just reuse the default or Pop if present. Adjust once you know the exact cursor name. [web:63]
        name = "Pop";
        # no dedicated package; XFCE will fall back gracefully
      };
    };

    ############################
    # XFCE settings (xfconf)
    ############################
    xfconf.settings = {
      xsettings = {
        "Net/ThemeName" =
          if cfg.variant == "dark"
          then "Pop-dark"
          else "Pop";

        "Net/IconThemeName" = "Pop";

        "Gtk/CursorThemeName" = "Pop";
      };

      xfwm4 = {
        # Use same name as GTK theme for window borders. [web:55][web:68]
        "general/theme" =
          if cfg.variant == "dark"
          then "Pop-dark"
          else "Pop";
        "general/title_font" = "Inter Bold 10";
        "general/button_layout" = "O|HMC";
      };

      # Optional: basic panel layout defaults for Pop-like look.
      # You can refine these once you export your actual xfconf panel setup.
      xfce4-panel = {
        "panels" = [1 2];

        # Top panel (status bar) [web:24]
        "panels/panel-1/position"      = "p=6;x=0;y=0";  # top centered
        "panels/panel-1/size"          = 28;
        "panels/panel-1/length"        = 100;
        "panels/panel-1/length-adjust" = true;
        "panels/panel-1/mode"          = 0;
        "panels/panel-1/position-locked"  = true;

        # Bottom panel (icon-only taskbar)
        "panels/panel-2/position"      = "p=10;x=0;y=0"; # bottom centered
        "panels/panel-2/size"          = 40;
        "panels/panel-2/length"        = 100;
        "panels/panel-2/length-adjust" = true;
        "panels/panel-2/mode"          = 0;
        "panels/panel-2/position-locked"  = true;

        # Only: separator, docklike, separator (fixed IDs 20,21,22)
        "panels/panel-2/plugin-ids" = [20 21 22];

        # Left separator (expanded, transparent)
        "plugins/plugin-20"   = "separator";
        "plugins/plugin-20/expand" = true;
        "plugins/plugin-20/style"  = 0;

        # Center dock (Docklike Taskbar)
        "plugins/plugin-21"   = "docklike";
        "plugins/plugin-21/icon-size"        = 36;   # icon size in px
        "plugins/plugin-21/show-labels"      = false;
        "plugins/plugin-21/group-windows"    = true;
        "plugins/plugin-21/show-only-pinned" = false;
        "plugins/plugin-21/indicator-style"  = 0;    # 0/1/2 – varies by version

        # Right separator (expanded, transparent)
        "plugins/plugin-22"   = "separator";
        "plugins/plugin-22/expand" = true;
        "plugins/plugin-22/style"  = 0;
      };
    };

    ############################
    # Wallpapers
    ############################
    # There isn't a ready-made Pop wallpaper package in nixpkgs everywhere,
    # so here is a simple placeholder you can swap later. [web:58][web:65]
    home.file."Pictures/Wallpapers/PopOS".source =
      pkgs.fetchFromGitHub {
        owner = "pop-os";
        repo = "gtk-theme";
        rev = "master";
        # You will need to update this hash after first build.
        hash = "sha256-MBcbrcZlFANWvw4W8kDn+C99c0xp7FXnM/BlB5C3sAw=";
      } + "/wallpapers";

    ############################
    # Optional: restart XFCE panel on switch
    ############################
    home.activation.restartXfcePanel =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if pgrep xfce4-panel >/dev/null; then
          xfce4-panel --restart
        fi
      '';
  };
}

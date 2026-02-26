{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.home.themeOptions.SmallSur;
in
{
  options.home.themeOptions.SmallSur = {
    variant = mkOption {
      type = types.enum [ "dark" "light" ];
      default = "dark";
      description = "Light or dark WhiteSur variant.";
    };
  };

  config = mkIf (config.home.theme == "SmallSur") {

    ############################
    # Packages (XFCE + theming)
    ############################
    home.packages = with pkgs; [
      # XFCE plugins (rough equivalents to apt packages)
      # xfce.xfce4-appmenu-plugin
      # xfce.xfce4-indicator-plugin
      # xfce.xfce4-statusnotifier-plugin
      xfce.xfce4-power-manager
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-notifyd

      # Themes
      whitesur-gtk-theme
      whitesur-icon-theme
      whitesur-cursors

      # Dock (Plank)
      plank
    ];

    ############################
    # GTK theming
    ############################
    gtk = {
      enable = true;

      theme = {
        name =
          if cfg.variant == "dark"
          then "WhiteSur-Dark"
          else "WhiteSur-Light";
        package = pkgs.whitesur-gtk-theme;
      };

      iconTheme = {
        name =
          if cfg.variant == "dark"
          then "WhiteSur-dark"
          else "WhiteSur-light";
        package = pkgs.whitesur-icon-theme;
      };

      cursorTheme = {
        name = "WhiteSur Cursors";
        package = pkgs.whitesur-cursors;
      };
    };

    ############################
    # XFCE settings (xfconf)
    ############################
    xfconf.settings = {
      xsettings = {
        "Net/ThemeName" =
          if cfg.variant == "dark"
          then "WhiteSur-Dark"
          else "WhiteSur-Light";

        "Net/IconThemeName" =
          if cfg.variant == "dark"
          then "WhiteSur-dark"
          else "WhiteSur-light";

        "Gtk/CursorThemeName" = "WhiteSur Cursors";
      };
    };

    ############################
    # Wallpapers
    ############################
    home.file."Pictures/Wallpapers".source =
      pkgs.fetchFromGitHub {
        owner = "jothi-prasath";
        repo = "WhiteSur-gtk-theme";
        rev = "master";
        hash = "sha256-FABEot2QDtuEfcfXpouxE6W6xU5GmSzl4HgZia/ALyU="; # replace after first build
      } + "/wallpapers";

    ############################
    # Plank themes
    ############################
    home.file.".local/share/plank/themes".source =
      pkgs.whitesur-gtk-theme + "/share/plank/themes";

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

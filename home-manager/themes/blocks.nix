{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.home.themeOptions.SmallSur;
in
{
  config  = mkIf (config.home.theme == "Blocks") {
    home.packages = with pkgs; [
      xfce.xfce4-genmon-plugin
      matcha-gtk-theme
      papirus-icon-theme
    ];

    home.activation.restartXfcePanel =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if pgrep xfce4-panel >/dev/null; then
          xfce4-panel --restart
        fi
      '';

    gtk = {
      enable = true;
      theme = {
        name = "Matcha-Azul";
        package = pkgs.papirus-icon-theme;
      };

      iconTheme = {
        name = "Papirus-dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    xfconf.settings = {
      xsettings = {
        "Net/ThemeName" = "Matcha-Azul";
        "Net/IconThemeName" = "Papirus-dark";
      };
    };
  };
}
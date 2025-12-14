{ config, pkgs, lib, ... }:

let
  themePresets = {
    smallSur-light = {
      packages = [
        pkgs.whitesur-gtk-theme
        pkgs.whitesur-icon-theme
        pkgs.capitaine-cursors
      ];
      gtkTheme = "WhiteSur-light";
      iconTheme = "WhiteSur";
      cursorTheme = "capitaine-cursors";
      wmTheme = "WhiteSur-light";
      wallpaperPkg = pkgs.stdenv.mkDerivation rec {
        pname = "small-sur-wallpaper";
        version = "1.0";
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/jothi-prasath/SmallSur/refs/heads/master/wallpaper/smallsur.png";
          sha256 = "sha256-43xHDuZgabYuQjo6NvPyWHv2wq3yn0WJX9OrlkAEO9U=";
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/wallpapers
          cp $src $out/share/wallpapers/smallsur.png
        '';
      };
      wallpaperPath = "smallsur.png";
    };

    smallSur-dark = {
      packages = [
        pkgs.whitesur-gtk-theme
        pkgs.whitesur-icon-theme
        pkgs.whitesur-cursors
      ];
      gtkTheme = "WhiteSur-dark";
      iconTheme = "WhiteSur-dark";
      cursorTheme = "WhiteSur-cursors";
      wmTheme = "WhiteSur-dark";
      wallpaperPkg = pkgs.stdenv.mkDerivation rec {  # Example—replace
        pname = "dark-wallpaper";
        version = "1.0";
        src = pkgs.fetchurl {
          url = "https://example.com/dark.png";  # Your URL
          sha256 = lib.fakeSha256;  # nix-prefetch-url it
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/wallpapers
          cp $src $out/share/wallpapers/dark.png
        '';
      };
      wallpaperPath = "dark.png";
    };

    adwaita = {
      packages = [];  # ✅ Clean—no bloat!
      gtkTheme = "Adwaita";
      iconTheme = "Adwaita";
      cursorTheme = "Adwaita";
      wmTheme = "Adwaita";
      wallpaperPkg = null;
      wallpaperPath = "";
    };
  };
  currentTheme = lib.getAttr config.desktop.themes.preset themePresets;

in {
  options.desktop.themes = {
    enable = lib.mkEnableOption "Modular XFCE themes (per-preset packages)";
    preset = lib.mkOption {
      type = lib.types.enum (lib.attrNames themePresets);
      default = "adwaita";
    };
  };

  config = lib.mkIf config.desktop.themes.enable {
    environment.systemPackages = currentTheme.packages
      ++ lib.optionals (currentTheme.wallpaperPkg != null) [ currentTheme.wallpaperPkg ];

    services.xserver.desktopManager.xfce.extraSessionCommands = ''
      xfconf-query -c xsettings -p /Net/ThemeName -s "${currentTheme.gtkTheme}"
      xfconf-query -c xsettings -p /Net/IconThemeName -s "${currentTheme.iconTheme}"
      xfconf-query -c xsettings -p /Net/CursorThemeName -s "${currentTheme.cursorTheme}"
      xfconf-query -c xfwm4 -p /general/theme -s "${currentTheme.wmTheme}"
      ${lib.optionalString (currentTheme.wallpaperPkg != null) ''
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-path -s "${currentTheme.wallpaperPkg}/share/wallpapers/${currentTheme.wallpaperPath}"
      ''}
    '';

    environment.etc."xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${currentTheme.gtkTheme}
      gtk-icon-theme-name=${currentTheme.iconTheme}
      gtk-cursor-theme-name=${currentTheme.cursorTheme}
      gtk-font-name=Sans 10
    '';

    environment.etc."xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${currentTheme.gtkTheme}
      gtk-icon-theme-name=${currentTheme.iconTheme}
      gtk-cursor-theme-name=${currentTheme.cursorTheme}
    '';
  };
}
{ config, pkgs, lib, ... }:

let
  # --- Individual sources ---
  smallSurGtk = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-gtk-theme";
    rev = "2025-07-24";
    sha256 = "sha256-tuon9XxMdrz9XNTp50sbss2gtx6H9hEZh8t2jSoqx28=";
  };

  bigSurIcons = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-icon-theme";
    rev = "2025-08-02";
    sha256 = "sha256-oBKDvCVHEjN6JT0r0G+VndzijEWU9L8AvDhHQTmw2E4=";
  };

  macCursor = pkgs.fetchFromGitHub {
    owner = "keeferrourke";
    repo = "capitaine-cursors";
    rev = "master";
    sha256 = "sha256-xc3Txy+yV+tX7Ks+Uwy2GbqwgmnNbI85SYlk0hMttzI=";
  };

  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/jothi-prasath/SmallSur/refs/heads/master/wallpaper/smallsur.png";
    sha256 = "sha256-43xHDuZgabYuQjo6NvPyWHv2wq3yn0WJX9OrlkAEO9U=";
  };

  # --- Compose them into one theme derivation ---
  smallSurTheme = pkgs.stdenv.mkDerivation {
    pname = "smallsur-theme";
    version = "2025-10-01";
    dontUnpack = true;

    installPhase = ''
      echo "Installing SmallSur theme..."
      mkdir -p $out/share/{themes,icons,wallpapers}

      echo "Extracting GTK themes from releases..."
      for archive in ${smallSurGtk}/releases/*.tar.xz; do
        echo "  -> Extracting $(basename "$archive")"
        tar -xf "$archive" -C $out/share/themes/
      done

      echo "Installing cursors..."
      mkdir -p $out/share/icons/capitaine-cursors
      cp -rL ${macCursor}/src/svg/* $out/share/icons/capitaine-cursors || true

      echo "Installing WhiteSur icons..."
      mkdir -p $out/share/icons/WhiteSur
      cp -rL ${bigSurIcons}/src/* $out/share/icons/WhiteSur/ || true

      echo "Copying variant folders..."
      for variant in bold bolder colors original; do
        if [ -d ${bigSurIcons}/src/$variant ]; then
          cp -rL ${bigSurIcons}/src/$variant/* $out/share/icons/WhiteSur/
        fi
      done

      echo "Copying wallpaper..."
      cp ${wallpaper} $out/share/wallpapers/smallsur.png

      echo "✅ SmallSur theme installed."
    '';
  };

in {
  options.themes.smallSur.enable = lib.mkEnableOption "Enable the SmallSur-style XFCE setup";

  config = lib.mkIf config.themes.smallSur.enable {
    environment.systemPackages = with pkgs; [
      smallSurTheme
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-docklike-plugin
      xfce.xfce4-panel-profiles
      xfce.xfce4-pulseaudio-plugin
    ];

    # GTK/XFCE appearance setup
    services.xserver.desktopManager.xfce.extraSessionCommands = ''
      xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-light"
      xfconf-query -c xsettings -p /Net/IconThemeName -s "WhiteSur"
      xfconf-query -c xsettings -p /Net/CursorThemeName -s "capitaine-cursors"
      xfconf-query -c xfwm4 -p /general/theme -s "WhiteSur-light"
      xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "${smallSurTheme}/share/wallpapers/smallsur.png"
    '';

    # Declarative GTK settings
    environment.etc."xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=WhiteSur-light
      gtk-icon-theme-name=WhiteSur
      gtk-cursor-theme-name=capitaine-cursors
      gtk-font-name=Sans 10
    '';
  };
}

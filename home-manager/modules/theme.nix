{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.home.theme;
in
{
  options.home.theme = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = ''
      Theme name. Each theme lives in ./modules/theme/<name-hyphenated>.nix.
      E.g., "SmallSur" → ./modules/theme/small-sur.nix
    '';
    example = "SmallSur";
  };

  config = mkIf (config.home.theme != null) (mkMerge [
    # Common base (GTK/Qt/dconf for all themes)
    {
      home.packages = [ pkgs.gtk3 pkgs.libsForQt5.qt5ct ];
      gtk.enable = true;
      qt.enable = true;
      dconf.enable = true;
    }

    # Dynamic theme impl (separate file per theme)
    (if config.home.theme == "SmallSur" then (import ./themes/small-sur.nix { inherit pkgs lib config; }) else {})
    # Add more: else if cfg == "Nord" then import ./nord.nix ...
  ]);
}
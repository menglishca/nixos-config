{ config, lib, pkgs, ... }:

{
  # A theme module should describe a visual identity.
  # This is the right place for Stylix choices like wallpaper, fonts,
  # polarity, and color scheme.
  #
  # As you create more rices, make one file per rice:
  #   modules/themes/gruvbox.nix
  #   modules/themes/catppuccin.nix
  #   modules/themes/my-rice.nix
  #
  # Then switch hosts between them by changing the import list.

  stylix.image = ./wallpaper.png;
  stylix.polarity = "dark";

  # Replace this with a real base16 scheme or Stylix-supported theme.
  # Keeping it commented helps the file evaluate even before you pick one.
  # stylix.base16Scheme = "
  #   base00: 1d2021
  #   base01: 3c3836
  #   ...
  # ";
}

{ config, lib, pkgs, ... }:

{
  # Stylix is the plumbing that applies a theme to many programs.
  # The actual artistic choices should live in modules/themes/*.nix.
  # In other words:
  # - this file says "we use Stylix"
  # - theme files say "what theme we want"

  stylix.enable = true;

  # Minimal default so Stylix doesn't assert; theme should override this.
  stylix.base16Scheme = {
    base00 = "000000";
    base01 = "111111";
    base02 = "222222";
    base03 = "333333";
    base04 = "444444";
    base05 = "555555";
    base06 = "666666";
    base07 = "777777";
    base08 = "888888";
    base09 = "999999";
    base0A = "aaaaaa";
    base0B = "bbbbbb";
    base0C = "cccccc";
    base0D = "dddddd";
    base0E = "eeeeee";
    base0F = "ffffff";
  };
}

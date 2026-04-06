{ config, lib, pkgs, ... }:

{
  # Stylix is the plumbing that applies a theme to many programs.
  # The actual artistic choices should live in modules/themes/*.nix.
  # In other words:
  # - this file says "we use Stylix"
  # - theme files say "what theme we want"

  stylix.enable = true;
}

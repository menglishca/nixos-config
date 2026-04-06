# modules/home/theme.nix
{ config, pkgs, lib, ... }:

let
  registry   = import ./themes/registry.nix;
  themeNames = builtins.attrNames registry;

  themeModules =
    map (path: import path) (builtins.attrValues registry);
in
{
  imports = themeModules;

  options.home.theme = lib.mkOption {
    type = lib.types.enum themeNames;
    default = builtins.head themeNames;
    description = "Active theme from themes/registry.nix.";
  };
}
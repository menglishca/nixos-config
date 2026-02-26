{ config, pkgs, lib, ... }:

let
  registry = import ../themes/registry.nix;
  themeNames = builtins.attrNames registry;

  # Import every theme module listed in the registry.
  # This does NOT depend on config, so it avoids recursion.
  themeModules =
    map (path: import path) (builtins.attrValues registry);

in
{
  imports = themeModules;

  options.home.theme = lib.mkOption {
    type = lib.types.enum themeNames;
    default = builtins.head themeNames;
    description = "Active theme (from themes/registry.nix).";
  };
}

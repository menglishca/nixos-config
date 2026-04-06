# Desktop modules

This folder holds desktop-related NixOS modules.

- `default.nix`: the desktop preset entry point
- `xfce.nix`: X11, LightDM, and XFCE enablement
- `fonts.nix`: system fonts
- `packages.nix`: desktop-wide XFCE plugins and extras

Import `./default.nix` from a host unless you have a reason to import the submodules directly.

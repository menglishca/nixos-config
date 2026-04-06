#!/usr/bin/env bash
set -euo pipefail

# Quick one-shot helper to split an old desktop-configuration.nix into:
#   modules/nixos/desktop/default.nix
#   modules/nixos/desktop/xfce.nix
#   modules/nixos/desktop/fonts.nix
#   modules/nixos/desktop/packages.nix
#
# This is intentionally quick-and-dirty:
# - it writes fixed files based on the pasted desktop config you showed
# - it backs up any files it overwrites
# - it does not attempt smart parsing
# - it updates a host file import if it finds the old desktop import
#
# Usage:
#   ./split-desktop-config.sh /path/to/repo [host]
# Example:
#   ./split-desktop-config.sh ~/code/nixos desktop

REPO="${1:-.}"
HOST="${2:-desktop}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR=".desktop-split-backup-${STAMP}"

cd "$REPO"
mkdir -p "$BACKUP_DIR"

backup_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$path")"
    cp -a "$path" "$BACKUP_DIR/$path"
  fi
}

write_file() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  cat > "$path"
}

backup_if_exists "desktop-configuration.nix"
backup_if_exists "modules/nixos/desktop.nix"
backup_if_exists "hosts/$HOST/default.nix"
backup_if_exists "README.md"

mkdir -p modules/nixos/desktop

write_file modules/nixos/desktop/default.nix <<'EOF2'
{ config, lib, pkgs, ... }:

{
  # Desktop preset entry point.
  # Hosts should import this file instead of each submodule directly.
  imports = [
    ./xfce.nix
    ./fonts.nix
    ./packages.nix
  ];
}
EOF2

write_file modules/nixos/desktop/xfce.nix <<'EOF2'
{ config, lib, pkgs, ... }:

{
  # XFCE + X11 + LightDM setup.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce";
    };

    desktopManager.xfce.enable = true;
  };

  # Remove XFCE apps you do not want when enabling the desktop.
  environment.xfce.excludePackages = [
    pkgs.xfce.xfce4-terminal
    pkgs.xfce.mousepad
  ];
}
EOF2

write_file modules/nixos/desktop/fonts.nix <<'EOF2'
{ config, lib, pkgs, ... }:

{
  # System-wide fonts used by the desktop.
  fonts = {
    fontconfig.enable = true;
    packages = [
      pkgs.nerd-fonts.sauce-code-pro
    ];
  };
}
EOF2

write_file modules/nixos/desktop/packages.nix <<'EOF2'
{ config, lib, pkgs, ... }:

{
  # Desktop-wide XFCE plugins and extras.
  environment.systemPackages = with pkgs.xfce; [
    xfce4-whiskermenu-plugin
    xfce4-docklike-plugin
    xfce4-panel-profiles
    xfce4-pulseaudio-plugin
  ];
}
EOF2

# Optional compatibility wrapper so existing imports do not break immediately.
write_file modules/nixos/desktop.nix <<'EOF2'
{ config, lib, pkgs, ... }:

{
  # Compatibility wrapper.
  # Old imports of ../../modules/nixos/desktop.nix will still work.
  imports = [
    ./desktop/default.nix
  ];
}
EOF2

# If the host file exists, try to switch import paths from desktop.nix to desktop/default.nix.
if [[ -f "hosts/$HOST/default.nix" ]]; then
  python3 - <<PY
from pathlib import Path
p = Path("hosts/$HOST/default.nix")
text = p.read_text()
text = text.replace("../../modules/nixos/desktop.nix", "../../modules/nixos/desktop/default.nix")
p.write_text(text)
PY
fi

# Archive the old desktop config instead of deleting it.
if [[ -f desktop-configuration.nix ]]; then
  mv desktop-configuration.nix "$BACKUP_DIR/desktop-configuration.nix.moved"
fi

# Add a small README if the desktop folder does not already have one.
if [[ ! -f modules/nixos/desktop/README.md ]]; then
  write_file modules/nixos/desktop/README.md <<'EOF2'
# Desktop modules

This folder holds desktop-related NixOS modules.

- `default.nix`: the desktop preset entry point
- `xfce.nix`: X11, LightDM, and XFCE enablement
- `fonts.nix`: system fonts
- `packages.nix`: desktop-wide XFCE plugins and extras

Import `./default.nix` from a host unless you have a reason to import the submodules directly.
EOF2
fi

cat <<EOF2
Done.

Created:
  modules/nixos/desktop/default.nix
  modules/nixos/desktop/xfce.nix
  modules/nixos/desktop/fonts.nix
  modules/nixos/desktop/packages.nix
  modules/nixos/desktop.nix

Backup dir:
  $BACKUP_DIR

Next:
  1. Open hosts/$HOST/default.nix and confirm the desktop import
  2. Run: nix flake check
  3. Run: sudo nixos-rebuild build --flake .#$HOST
EOF2

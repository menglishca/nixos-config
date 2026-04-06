{ config, lib, pkgs, ... }:

{
  # System packages are available to all users.
  # Prefer Home Manager for user-specific tools, shells, and dotfiles.
  environment.systemPackages = with pkgs; [
    firefox
    nano
    killall
    featherpad
    redshift
    keepassxc
    anydesk
    zoom-us
    vlc
    qbittorrent
    temurin-bin-21
    alacritty
  ];

  virtualisation.virtualbox.host = {
    enable = false;
    enableExtensionPack = true;
  };
}

{ config, lib, pkgs, ... }:

{
  # System packages are available to all users.
  # Prefer Home Manager for user-specific tools, shells, and dotfiles.
  environment.systemPackages = with pkgs; [
    alacritty
    anydesk
    git
    featherpad
    firefox
    keepassxc
    killall
    nano
    pamixer
    pulseaudio
    qbittorrent
    redshift
    temurin-bin-21
    vlc
    zoom-us
  ];

  virtualisation.virtualbox.host = {
    enable = false;
    enableExtensionPack = true;
  };
}

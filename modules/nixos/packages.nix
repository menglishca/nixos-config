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
    jq
    keepassxc
    killall
    nano
    pamixer
    pulseaudio
    qbittorrent
    redshift
    temurin-bin-21
    tmux
    vlc
  ];

  virtualisation.virtualbox.host = {
    enable = false;
    enableExtensionPack = true;
  };
}

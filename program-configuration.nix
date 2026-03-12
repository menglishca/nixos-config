{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/unfree.nix
    ./programs/git-configuration.nix
  ];
  allowedUnfreePackages = with pkgs; [
    "discord"      # Proprietary
    "anydesk"      # Proprietary
    "zoom"      # Proprietary (client)
    "vscode"       # MS (core)
    "Oracle_VirtualBox_Extension_Pack"
  ];
  environment.systemPackages = with pkgs; [
    firefox
    nano
    killall
    featherpad
    galculator
    redshift
    keepassxc
    # discord
    # eddie
    # virtualbox
    anydesk
    zoom-us
    vlc
    qbittorrent
    temurin-bin-21
    redshift
    alacritty
  ];

  virtualisation.virtualbox.host = {
    enable = false;
    enableExtensionPack = true;
  };
}

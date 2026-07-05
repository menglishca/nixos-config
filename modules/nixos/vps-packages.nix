{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    jq
    librechat
    nano
    python3
    tmux
  ];
}

# modules/home/programs/tmux.nix
{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "emacs";
    newSession = true;
    prefix = "C-b";
    shell = "${pkgs.bash}/bin/bash";
    extraConfig = ''
      # Pane navigation (arrow keys)
      bind-key Left  select-pane -L
      bind-key Right select-pane -R
      bind-key Up    select-pane -U
      bind-key Down  select-pane -D
    '';
  };
}
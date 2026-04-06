# modules/home/programs/bash.nix
{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls     = "ls --color=auto";
      dir    = "dir --color=auto";
      vdir   = "vdir --color=auto";
      grep   = "grep --color=auto";
      fgrep  = "fgrep --color=auto";
      egrep  = "egrep --color=auto";
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };
  };
}
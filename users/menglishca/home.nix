{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/programs/bash.nix
    ../../modules/home/programs/git.nix
    ../../modules/home/programs/tmux.nix
  ];

  home = {
    username = "matthew";
    homeDirectory = "/home/matthew";
  };
}

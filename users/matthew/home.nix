{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/git.nix
  ];

  # This file is your user-level composition root.
  # Keep it readable. It should answer:
  # - which home modules does this user want?
  # - which user-specific choices differ from other users?
}

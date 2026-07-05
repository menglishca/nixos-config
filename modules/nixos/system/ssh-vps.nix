{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    # Remove the restrictive SSH rules from ssh.nix and allow SSH from anywhere.
    extraInputRules = lib.mkForce ''
      tcp dport 22 accept
    '';
  };
}

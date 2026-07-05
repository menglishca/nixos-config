{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/vps-packages.nix
    ../../modules/nixos/services/postgres.nix
    ../../modules/nixos/services/librechat.nix
    ../../modules/nixos/services/ssh/server.nix
    ../../modules/nixos/system/env/server.nix
  ];

  networking.hostName = "menglishca";

  users.users.matthew = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFt4R/A+CRnIppi/7/xElUVrj0CyLe7nRLpwoIndIoE matthew-menglishca-desktop"
    ];
  };
}

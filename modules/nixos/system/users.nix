{ config, lib, pkgs, ... }:

{
  users.users = {
    # The repeated "users.users" naming is normal in NixOS.
    matthew = {
      isNormalUser = true;
      description = "Matthew";
      extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
      initialPassword = "changeme";
    };

    root = {
      initialPassword = "changeme";
    };
  };
}
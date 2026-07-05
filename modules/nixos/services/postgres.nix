{ config, lib, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;

    # Add extensions or configure databases here as needed.
    # Ensure the `matthew` user can manage databases.
    settings = {
      listen_addresses = "127.0.0.1";
    };
  };

  networking.firewall.allowedTCPPorts = [ ];
}

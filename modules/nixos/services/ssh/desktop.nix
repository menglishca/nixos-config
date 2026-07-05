{ config, lib, pkgs, ... }:

{
    imports = [
        ./default.nix
    ];

    services.openssh = {
        settings = {
            PermitRootLogin = "yes";
            PasswordAuthentication = true;
        };
    };

    networking.firewall = {
        allowedTCPPorts = [ ];

        # Allow SSH only from private/local networks.
        extraInputRules = ''
            ip saddr 192.168.0.0/16 tcp dport 22 accept
            ip saddr 10.0.0.0/8 tcp dport 22 accept
            ip saddr 172.16.0.0/12 tcp dport 22 accept
            ip6 saddr fd00::/8 tcp dport 22 accept
            tcp dport 22 drop
        '';
    };
}
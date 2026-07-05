{ config, lib, pkgs, ... }:

{
    imports = [
        ./default.nix
    ];

    services.openssh = {
        settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
        };
    };
}
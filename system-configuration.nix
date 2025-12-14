{ config, lib, pkgs, ... }:

{
  system.stateVersion = "25.05";
  users = {
    users = { #Weird duplicate naming convention, but apparently required
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
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ ]; # don't globally allow 22

      #Only allow SSH from private networks
      extraInputRules = ''
        # IPv4 private ranges
        ip saddr 192.168.0.0/16 tcp dport 22 accept
        ip saddr 10.0.0.0/8 tcp dport 22 accept
        ip saddr 172.16.0.0/12 tcp dport 22 accept

        # IPv6 ULA (Unique Local Addresses)
        ip6 saddr fd00::/8 tcp dport 22 accept

        # Drop all other SSH traffic
        tcp dport 22 drop
      '';
    };
  };

  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin-21}/lib/openjdk";
    TERMINAL = "${pkgs.rxvt-unicode-unwrapped}/bin/urxvt";
  };
}

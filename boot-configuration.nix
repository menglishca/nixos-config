# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
#  imports = [
#    ./modules/refind/refind.nix
#  ];
  boot = {
    loader = {
      systemd-boot = {
        enable = false;
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
#      refind = {
#        enable = true;
#        maxGenerations = 1;
#        additionalFiles = {
#          "themes/refind-theme-regular" = pkgs.fetchFromGitHub {
#            owner = "bobafetthotmail";
#            repo = "refind-theme-regular";
#            rev = "master";
#            sha256 = "sha256-Lj+BnX/16kEkjM/fRHd4XLJ9jlBvSMAwKF4FMeD75/I=";
#            postFetch = ''
#              mkdir -p $out
#              cp -r $extractDir/* $out/
#            '';
#          };
#          "themes/text.txt" = "/etc/nixos/system-configuration.nix";
#        };
#        extraConfig = ''
#          timeout 10
#          use_graphics_for osx,linux,windows
#          showtools reboot,shutdown,shell,about
#          hideui singleuser,hints
#          include themes/refind-theme-regular/theme.conf
#          scanfor manual,external
#          submenuentry "Advanced Options for NixOS" {
#            
#          }
#        '';
#      };
    };
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader.timeout = 0; 
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/St_Johns";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;
}

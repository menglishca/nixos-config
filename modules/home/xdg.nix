# modules/home/xdg.nix
{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;

    userDirs = let
      lower = path: "${config.home.homeDirectory}/${path}";
    in {
      enable = true;
      createDirectories = true;
      userDirs.setSessionVariables = true;

      desktop     = lower "desktop";
      documents   = lower "documents";
      download    = lower "downloads";
      music       = lower "music";
      pictures    = lower "pictures";
      publicShare = lower "public";
      templates   = lower "templates";
      videos      = lower "videos";
      desktopEntries = {
        alacritty = {
          name = "Alacritty";
          exec = "${pkgs.alacritty}/bin/alacritty";
          icon = "terminal";
          categories = [ "System" "TerminalEmulator" ];
          mimeType = [ "text/plain" ];
        };
      };
    };
  };
}
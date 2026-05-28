# modules/home/xdg.nix
{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    desktopEntries = {
      enable = true;
      alacritty = {
        name = "Alacritty";
        exec = "alacritty";
        icon = "terminal";
        terminal = false;
        categories = [ "System" "TerminalEmulator" ];
        mimeType = [ "text/plain" ];
      };
    };

    userDirs = let
      lower = path: "${config.home.homeDirectory}/${path}";
    in {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      desktop     = lower "desktop";
      documents   = lower "documents";
      download    = lower "downloads";
      music       = lower "music";
      pictures    = lower "pictures";
      publicShare = lower "public";
      templates   = lower "templates";
      videos      = lower "videos";
    };
  };
}
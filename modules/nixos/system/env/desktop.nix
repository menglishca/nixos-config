{ config, lib, pkgs, ... }:

{
  # Desktop-specific environment variables.
  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin-21}/lib/openjdk";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };
}

{ config, lib, pkgs, ... }:

{
  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin-21}/lib/openjdk";
    TERMINAL = "${pkgs.rxvt-unicode-unwrapped}/bin/urxvt";
  };
}
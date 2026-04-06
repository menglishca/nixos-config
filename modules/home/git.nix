{ config, lib, pkgs, ... }:

{
  # This is a Home Manager module.
  # Git is a good first example because it is mostly a user preference.
  programs.git = {
    enable = true;
    config = {
      alias = {
        set-upstream = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD)";
        "undo-commit" = "reset --soft HEAD~1";
        "current-branch" = "symbolic-ref --short HEAD";
      };
    };
  };
}

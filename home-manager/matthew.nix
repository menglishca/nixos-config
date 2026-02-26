{ config, pkgs, ... }: {
  imports = [ ./modules/theme.nix ];

  home = {
    username = "matthew";
    homeDirectory = "/home/matthew";
    stateVersion = "25.05";
    theme = "Blocks";
  };
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ls = "ls --color=auto";
        dir = "dir --color=auto";
        vdir = "vdir --color=auto";
        grep = "grep --color=auto";
        fgrep = "fgrep --color=auto";
        egrep = "egrep --color=auto";
        pbcopy = "xclip -selection clipboard";
        pbpaste = "xclip -selection clipboard -o";
      };
    };
    tmux = {
      enable = true;
      keyMode = "emacs";
      newSession = true;
      prefix = "C-b";
      shell =  "\${pkgs.bash}/bin/bash";
      extraConfig = ''
          # Pane navigation (arrow keys)
          bind-key Left  select-pane -L
          bind-key Right select-pane -R
          bind-key Up    select-pane -U
          bind-key Down  select-pane -D
      '';
    };
    urxvt = {
      enable = true;
      fonts = [
        "xft:SauceCodePro Nerd Font:size=10"
        "xft:SauceCodePro Nerd Font:bold:size=10"  # Bold variant
      ];
      iso14755 = true;
      keybindings = {
        "Shift-Control-C" = "eval:selection_to_clipboard";
        "Shift-Control-V" = "eval:paste_clipboard";
      };
      transparent = true;
      scroll = {
        bar = {
          enable = false;
        };
      };
      shading = 90;
      extraConfig = {
        "depth" = 32;
        "visualbell" = false;
        "borderless" = true;
        "internalBorder" = 20;
        "perl-ext-common" = "default,matcher,keyboard-select";
      };
    };
  };
}
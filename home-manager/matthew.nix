{ config, pkgs, ... }: {
    imports = [ ./modules/theme.nix ./programs/vscode-base.nix ];

    home = {
        username = "matthew";
        homeDirectory = "/home/matthew";
        stateVersion = "25.05";
        theme = "PopOS";
        themeOptions = {
            PopOS = {
                variant = "light";
            };
        };

        #file."pictures/current-wallpaper.jpg".source = ./. + "/wallpapers/brain.jpg";
    };

    xdg = {
        enable = true;

        userDirs = let
            lower = path: "${config.home.homeDirectory}/${path}";
        in {
            enable = true;
            createDirectories = true;

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

    # Tell Stylix (in the Home Manager context) not to theme GNOME
    stylix = {
        # Do NOT re-set enable/autoEnable/base16Scheme here; those come from NixOS.
        targets = {
            alacritty.enable = true;
            gnome.enable = false;
            firefox = {
                enable = true;
                profileNames = [ "main" ];
            };
            rofi = {
                enable = true;
                fonts.enable = true;
                opacity.enable = true;
            };
            vscode.enable = true;
        };
        image = /. + "/${config.home.homeDirectory}/pictures/current-wallpaper.jpg";
    };

    programs = {
        alacritty = {
            enable = true;
            settings.font = {
                offset = {
                    x = 0;
                    y = -1;
                };
            };
        };
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
        firefox = {
            enable = true;
            profiles."main" = {
                isDefault = true;
            };
        };
        rofi = {
            enable = true;
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
    };
}
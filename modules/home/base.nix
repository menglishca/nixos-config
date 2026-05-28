# modules/home/base.nix
{ config, lib, pkgs, ... }:

let
    populateDotfiles = { dotfilesDir, prefixDot ? true }:
        let
            recursivelyGetFiles = relativePath:
                let
                    dotfilesSourcePath = if relativePath == "" then dotfilesDir else dotfilesDir + "/${relativePath}";

                    entries =
                        if builtins.pathExists dotfilesSourcePath
                        then builtins.readDir dotfilesSourcePath
                        else {};
                in
                    lib.concatMap
                        (fileName:
                            let
                                filetype = entries.${fileName};
                                childRelativePath = if relativePath == "" then fileName else "${relativePath}/${fileName}";
                            in
                                if filetype == "directory"
                                then recursivelyGetFiles childRelativePath
                                else
                                    let
                                        pathParts = lib.splitString "/" childRelativePath;
                                        top = lib.head pathParts;
                                        rest = lib.tail pathParts;
                                        topWithDot = if prefixDot then ".${top}" else top;
                                        homePath = lib.concatStringsSep "/" ([ topWithDot ] ++ rest);
                                        fileName = lib.last pathParts;
                                        scriptExtensions = [ ".sh" ".bash" ".zsh" ".fish" ".py" ".rb" ".pl" ];
                                        hasScriptExt = lib.any (ext: lib.hasSuffix ext fileName) scriptExtensions;
                                        isInBinDir = lib.elem "bin" (lib.init pathParts);
                                        shouldBeExecutable = hasScriptExt || isInBinDir;
                                    in
                                        [
                                            {
                                                name  = homePath;
                                                value = {
                                                    source = dotfilesDir + "/${childRelativePath}";
                                                    executable = shouldBeExecutable;
                                                };
                                            }
                                        ]
                        )
                        (lib.attrNames entries);
        in
            lib.listToAttrs (recursivelyGetFiles "");
    mkDotfiles =  { path, name, prefixDot ? true }:
        if !builtins.pathExists path then
            {}
        else
            let
                dotfilesDir = builtins.path { inherit path name; };
            in
                populateDotfiles { inherit dotfilesDir prefixDot; };
    in
        {
            home.stateVersion = "25.11";
            programs.home-manager.enable = true;
            gtk.gtk4.theme = config.gtk.theme;
            _module.args.mkDotfiles = mkDotfiles;
        }
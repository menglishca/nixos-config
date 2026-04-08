# modules/home/base.nix
{ config, lib, pkgs, ... }:

let
  populateDotfiles =
    { dotfilesDir, prefixDot ? true }:
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
                  # Only files become home.file entries; directories are implicit
                  let
                    pathParts = lib.splitString "/" childRelativePath;
                    top   = lib.head pathParts;
                    rest  = lib.tail pathParts;
                    topWithDot = if prefixDot then ".${top}" else top;
                    homePath = lib.concatStringsSep "/" ([ topWithDot ] ++ rest);
                  in
                    [
                      {
                        name  = homePath;
                        value = { source = dotfilesDir + "/${childRelativePath}"; };
                      }
                    ]
            )
            (lib.attrNames entries);
    in
      lib.listToAttrs (recursivelyGetFiles "");
in
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  _module.args.populateDotfiles = populateDotfiles;
}
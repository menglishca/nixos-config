# modules/home/base.nix
{ config, lib, pkgs, ... }:

let
  populateDotfiles =
    { dotfilesDir, prefixDot ? true }:
    let
      recCollect = rootRel:
        let
          dirPath =
            if rootRel == "" then dotfilesDir else dotfilesDir + "/${rootRel}";

          entries =
            if builtins.pathExists dirPath
            then builtins.readDir dirPath
            else {};
        in
          lib.concatMap
            (name:
              let
                typ      = entries.${name};
                childRel = if rootRel == "" then name else "${rootRel}/${name}";
              in
              if typ == "directory"
              then recCollect childRel
              else
                # Only files become home.file entries; directories are implicit
                let
                  parts = lib.splitString "/" childRel;
                  top   = lib.head parts;
                  rest  = lib.tail parts;

                  topWithDot = if prefixDot then ".${top}" else top;

                  homePath =
                    lib.concatStringsSep "/" ([ topWithDot ] ++ rest);
                in
                [ {
                  name  = homePath;
                  value = { source = dotfilesDir + "/${childRel}"; };
                } ]
            )
            (lib.attrNames entries);
    in
      lib.listToAttrs (recCollect "");
in
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  _module.args.populateDotfiles = populateDotfiles;
}
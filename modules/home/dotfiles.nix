{ config, lib, pkgs, ... }:

let
  # Root of global dotfiles
  dotfilesDir = ./dotfiles;

  # Recursively build home.file entries.
  # rootRel is the path relative to dotfilesDir, e.g. "" or "bin" or "config/nvim".
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
          if typ == "directory" then
            recCollect childRel
          else
            # File: map to ~/.<top-level>/<subpath>
            let
              # Split "bin/foo/bar" -> [ "bin" "foo" "bar" ]
              parts       = lib.splitString "/" childRel;
              top         = lib.head parts;
              rest        = lib.tail parts;
              # Build ".bin/foo/bar" etc.
              homePath =
                lib.concatStringsSep "/" ([ ".${top}" ] ++ rest);
            in
            [ {
              name  = homePath;
              value = { source = dotfilesDir + "/${childRel}"; };
            } ]
        )
        (lib.attrNames entries);

  globalHomeFiles =
    lib.listToAttrs (recCollect "");
in
{
  home.file = globalHomeFiles;
}
{ config, lib, ... }: {
  options.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf(lib.types.str);
    default = [];
    description = "Allowlisted unfree package names";
  };

  config.nixpkgs.config.allowUnfreePredicate = nixPackage:
    builtins.elem (lib.getName nixPackage) config.allowedUnfreePackages;
}

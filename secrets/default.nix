{ lib, ulib, ... }: with ulib;

systemConfiguration {
  age.secrets = lib.genAttrs
    (map
      (lib.removeSuffix ".age")
      (builtins.attrNames
        (builtins.removeAttrs (import ./secrets.nix) [ "keys" ])))
    (name: { file = ./${name}.age; });
}

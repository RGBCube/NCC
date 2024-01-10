{ lib, ulib, ... }: with ulib;

systemConfiguration {
  age.secrets = lib.genAttrs
    (builtins.map
      (lib.removeSuffix ".age")
      (builtins.attrNames (import ./secrets.nix)))
    (name: { file = ./${name}.age; });
}

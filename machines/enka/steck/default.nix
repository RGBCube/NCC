{ lib, pkgs, systemConfiguration, systemPackages, ... }: lib.recursiveUpdate3

(systemConfiguration {
  environment.shellAliases.share = "steck paste";
})

(with pkgs; systemPackages [
  steck
])

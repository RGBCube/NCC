{ lib, pkgs, systemConfiguration, homePackages, ... }: lib.recursiveUpdate

(systemConfiguration {
  # Steam uses 32-bit drivers for some unholy fucking reason.
  hardware.opengl.driSupport32Bit = true;
})

(with pkgs; homePackages "nixos" [
  steam
])

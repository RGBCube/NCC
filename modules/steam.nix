{ lib, pkgs, ... }: with lib; merge

(desktopSystemConfiguration {
  # Steam uses 32-bit drivers for some unholy fucking reason.
  hardware.graphics.enable32Bit = true;
})

(desktopUserHomePackages (with pkgs; [
  steam
]))

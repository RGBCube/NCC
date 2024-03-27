{ lib, pkgs, ... }: with lib; merge

(desktopSystemConfiguration {
  # Steam uses 32-bit drivers for some unholy fucking reason.
  hardware.opengl.driSupport32Bit = true;

  nixpkgs.config.allowUnfree = true;
})

(desktopUserHomePackages (with pkgs; [
  steam
]))

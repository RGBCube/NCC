{ ulib, pkgs, ... }: with ulib;

systemConfiguration {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}

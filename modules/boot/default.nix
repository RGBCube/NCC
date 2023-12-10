{ ulib, pkgs, ... }: with ulib;

systemConfiguration {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader         = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable      = true;
    systemd-boot.editor      = false;
  };

  boot.tmp.cleanOnBoot = true;
}

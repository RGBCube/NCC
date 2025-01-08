{ config, lib, ... }: with lib;

systemConfiguration {
  boot.loader = {
    systemd-boot = enabled {
      editor = false;
    };

    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "sr_mod"
  ];

  fileSystems."/" = {
    device  = "/dev/disk/by-label/root";
    fsType  = "btrfs";
    options = [ "relatime" ];
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device  = "/dev/disk/by-label/boot";
    fsType  = "vfat";
    options = [ "relatime" "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];
}

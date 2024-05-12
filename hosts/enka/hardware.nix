{ config, lib, ... }: with lib;

systemConfiguration {
  boot.loader = {
    systemd-boot = enabled {
      editor = false;
    };

    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [
    "ahci"
    "rtsx_pci_sdmmc"
    "sd_mod"
    "sr_mod"
    "xhci_pci"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];

  hardware.enableAllFirmware         = true;
  hardware.cpu.intel.updateMicrocode = true;
}

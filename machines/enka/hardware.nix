{ systemConfiguration, enabled, ... }:

systemConfiguration {
  powerManagement.cpuFreqGovernor = "performance";

  boot.initrd.availableKernelModules = [
    "ahci"
    "rtsx_pci_sdmmc"
    "sd_mod"
    "sr_mod"
    "usb_storage"
    "xhci_pci"
  ];

  boot.loader = {
    systemd-boot             = enabled {};
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/add562e1-f2f6-4ac0-bb17-0acc380ac133";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D697-1FA1";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/7b21b5e9-6194-4448-9f65-3a744bfdc2b3";
    }
  ];
}

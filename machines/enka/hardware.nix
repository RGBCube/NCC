{ systemConfiguration, enabled, ... }:

systemConfiguration {
  powerManagement.cpuFreqGovernor = "performance";

  boot.initrd.availableKernelModules = [
    "ahci"
    "rtsx_pci_sdmmc"
    "sd_mod"
    "sr_mod"
    "usbhid"
    "xhci_pci"
  ];

  boot.loader = {
    systemd-boot             = enabled {};
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cc473c12-94a9-4399-a0ab-f080f9e786f6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D1F5-D862";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/f3a15cd2-9897-4867-9414-d4a8c3e71caf";
    }
  ];
}

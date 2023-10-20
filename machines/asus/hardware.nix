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
    device = "";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "";
    }
  ];
}

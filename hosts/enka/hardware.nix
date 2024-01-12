{ ulib, ... }: with ulib;

systemConfiguration {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable      = true;
    systemd-boot.editor      = false;
  };

  boot.initrd.availableKernelModules = [
    "ahci"
    "rtsx_pci_sdmmc"
    "sd_mod"
    "sr_mod"
    "xhci_pci"
  ];

  services = {
    devmon  = enabled {};
    gvfs    = enabled {};
    udisks2 = enabled {};
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
    { device = "/dev/disk/by-uuid/f3a15cd2-9897-4867-9414-d4a8c3e71caf"; }
  ];

  hardware.enableAllFirmware         = true;
  hardware.cpu.intel.updateMicrocode = true;
}

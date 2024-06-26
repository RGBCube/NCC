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
    "ehci_pci"
    "sd_mod"
    "sr_mod"
    "usb_storage"
    "usbhid"
  ];

  fileSystems."/" = {
    device  = "/dev/disk/by-label/root";
    fsType  = "btrfs";
    options = [ "noatime" ];
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device  = "/dev/disk/by-label/boot";
    fsType  = "vfat";
    options = [ "noatime" ];
  };

  hardware.enableAllFirmware         = true;
  hardware.cpu.intel.updateMicrocode = true;
}

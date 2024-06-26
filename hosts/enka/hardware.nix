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
    "nvme"
    "sr_mod"
    "usbhid"
    "xhci_pci"
  ];

  boot.kernelModules = [
    "kvm-intel"
  ];

  fileSystems."/" = {
    device  = "/dev/disk/by-label/root";
    fsType  = "btrfs";
    options = [ "noatime" ];
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device  = "/dev/disk/by-label/ESP";
    fsType  = "vfat";
    options = [ "noatime" ];
  };

  hardware.enableAllFirmware         = true;
  hardware.cpu.intel.updateMicrocode = true;
}

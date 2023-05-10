{ systemConfiguration, ... }:

systemConfiguration {
  powerManagement.cpuFreqGovernor = "performance";

  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "sr_mod"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];

  boot.kernelModules = [
    "kvm-intel"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d0e4626c-507e-484a-9ecc-94817d889083";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/A467-98D1";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/10bfe7d8-1daf-4c65-a5a6-cf3c9a085478";
    }
  ];
}

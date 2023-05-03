{ ... }:

{
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
}

{ hardware, config, lib, ... }: with lib;

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

  boot.kernelModules = [ "kvm-intel" ];

  imports = [ hardware.nixosModules.common-gpu-nvidia ];

  hardware.nvidia.prime = {
    intelBusId  = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

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

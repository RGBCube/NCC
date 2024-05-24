{ lib, modulesPath, ... }: with lib;

systemConfiguration {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub = enabled {
    device = "/dev/vda";
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "vmw_pvscsi"
    "xen_blkfront"
  ];

  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = {
    device  = "/dev/disk/by-label/root";
    fsType  = "ext4";
    options = [ "noatime" ];
  };
}

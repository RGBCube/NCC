{ config, lib, modulesPath, ... }: let
  inherit (lib) enabled;
in {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.loader.grub = enabled {
    efiSupport            = true;
    efiInstallAsRemovable = true;
    device                = "nodev";
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
  ];

  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  zramSwap = enabled;
}

{ config, lib, modulesPath, ... }: let
  inherit (lib) enabled;
in {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.loader.grub = enabled {
    efiSupport = false;
    device     = "/dev/vda";
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "sr_mod"
    "uhci_hcd"
    "virtio_blk"
    "virtio_pci"
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

  nixpkgs.hostPlatform = "x86_64-linux";
}

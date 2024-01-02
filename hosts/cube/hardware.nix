{ ulib, modulesPath, ... }: with ulib;

systemConfiguration {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub = enabled {
    device      = "/dev/vda";
    useOSProber = true;
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "sr_mod"
    "uhci_hcd"
    "virtio_blk"
    "virtio_pci"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a14e3685-693a-4099-a2fe-ce959935dd50";
    fsType = "ext4";
  };
}

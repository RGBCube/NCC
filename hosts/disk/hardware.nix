{ config, lib, modulesPath, ... }: let
  inherit (lib) enabled;
in {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.loader = {
    systemd-boot = enabled {
      editor = false;
    };

    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [
    "ahci"
    "ata_piix"
    "nvme"
    "sr_mod"
  ];

  fileSystems."/" = {
    device  = "/dev/disk/by-label/root";
    fsType  = "ext4";
    options = [ "noatime" ];
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device  = "/dev/disk/by-label/boot";
    fsType  = "vfat";
    options = [ "noatime" ];
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];

  nixpkgs.hostPlatform = "x86_64-linux";
}

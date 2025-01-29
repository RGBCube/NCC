{ pkgs, ... }: {
  # Steam uses 32-bit drivers for some unholy fucking reason.
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = [
    pkgs.steam
  ];
}

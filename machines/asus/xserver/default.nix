{ ... }:

{
  services.xserver.enable = true;
  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}

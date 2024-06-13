
{ hardware, lib, ... }: with lib;

systemConfiguration {
  imports = [ hardware.nixosModules.common-gpu-nvidia ];

  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

  boot.kernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];

  hardware.nvidia = {
    open            = false;
    powerManagement = enabled;

    prime = {
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.sessionVariables = {
    GBM_BACKEND               = "nvidia-drm";
    LIBVA_DRIVER_NAME         = "nvidia";
    NVD_BACKEND               = "direct";
    XDG_SESSION_TYPE          = "wayland";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}


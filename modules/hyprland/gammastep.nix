{ lib, ... }: with lib; merge 

(desktopSystemConfiguration {
  services.geoclue2 = enabled {
    appConfig.gammstep = {
      isAllowed = true;
      isSystem  = false;
    };
  };
})

(desktopUserHomeConfiguration {
  services.gammastep = enabled {
    provider = "geoclue2";
  };
})

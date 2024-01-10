{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.site = enabled {
    url            = config.networking.domain;
    configureNginx = true;
  };
}

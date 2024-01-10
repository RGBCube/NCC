{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.site = enabled {
    configureNginx = true;
  };
}

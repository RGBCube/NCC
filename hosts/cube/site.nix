{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.site = enabled {
    httpPort     = 80;
    httpsPort    = 443;
    openFirewall = true;
  };
}

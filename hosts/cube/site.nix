{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.site = { # enabled {
    openFirewall = true;
  };
}

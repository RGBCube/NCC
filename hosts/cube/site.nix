{ ulib, ... }: with ulib;

systemConfiguration {
  services.site = { # enabled {
    openFirewall = true;
  };
}

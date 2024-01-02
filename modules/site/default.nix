{ ulib, ... }: with ulib;

systemConfiguration {
  # TODO: Move to cube host.
  services.site = { # enabled {
    openFirewall = true;
  };
}

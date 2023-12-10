{ ulib, ... }: with ulib;

systemConfiguration {
  services.logind.powerKey = "ignore";
}

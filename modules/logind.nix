{ ulib, ... }: with ulib;

desktopSystemConfiguration {
  services.logind.powerKey = "ignore";
}

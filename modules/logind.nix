{ lib, ... }: with lib;

desktopSystemConfiguration {
  services.logind.powerKey = "ignore";
}

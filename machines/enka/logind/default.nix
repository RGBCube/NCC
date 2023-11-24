{ systemConfiguration, ... }:

systemConfiguration {
  services.logind.powerKey = "ignore";
}

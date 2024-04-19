{ lib, ... }: with lib;

systemConfiguration {
  services.kresd = enabled;

  networking.nameservers = [
    "::1"
    "127.0.0.1"

    "1.1.1.1"
    "8.8.8.8"
  ];
}

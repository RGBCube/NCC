{ lib, ... }: with lib;

systemConfiguration {
  services.kresd = enabled;

  networking.nameservers = [ "::1" "127.0.0.1" ];
}

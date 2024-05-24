{ config, self, lib, ... }: with lib;

let
  inherit (config.networking) domain;

  fqdn = "mail2.${domain}";
in systemConfiguration {
  imports = [(self + /hosts/disk/mail)];

  mailserver = {
    inherit fqdn;

    # Not [ domain ] because this is a backup mailserver. contact@mail2.rgbcu.be.
    domains = [ fqdn ];
  };
} 

{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;
in serverSystemConfiguration {
  security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.age.secrets.acme.path;
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "security@rgbcu.be";
    };

    certs.${domain} = {
      extraDomainNames = [ "*.${domain}" ];
      group            = "nginx";
    };
  };
}

{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;
in serverSystemConfiguration {
  security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.age.secrets."cube/password.acme".path;
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "security@${domain}";
    };

    certs.${domain} = {
      extraDomainNames = [ "*.${domain}" ];
      group            = "nginx";
    };
  };
}

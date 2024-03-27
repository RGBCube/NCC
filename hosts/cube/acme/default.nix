{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;
in serverSystemConfiguration {
  age.secrets."hosts/cube/acme/password".file = ./password.age;

  security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.age.secrets."hosts/cube/acme/password".path;
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

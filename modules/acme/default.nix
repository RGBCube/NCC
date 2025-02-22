{ config, ... }: let
  inherit (config.networking) domain;
in {
  secrets.acmeEnvironment.file = ./environment.age;

  security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.secrets.acmeEnvironment.path;
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

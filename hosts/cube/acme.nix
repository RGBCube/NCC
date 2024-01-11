{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.age.secrets.acme.path;
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "security@rgbcu.be";
    };

    certs.${config.networking.domain} = {
      extraDomainNames = [ "*.${config.networking.domain}" ];
      group            = "nginx";
    };
  };
}

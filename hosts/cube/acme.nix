{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  age.secrets.acme = {
    owner = "acme";
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      credentialsFile = config.age.secrets.acme.path;
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "rgbsphere@gmail.com";
      group           = "nginx";
    };

    certs."rgbcu.be".extraDomainNames = [ "*.rgbcu.be" ];
  };
}

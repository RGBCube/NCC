{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  security.acme = {
    acceptTerms = true;

    defaults = {
      credentialsFile = config.age.secrets.acme.path;
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "security@rgbcu.be";
      group           = "nginx";
    };

    certs."rgbcu.be".domain = "*.rgbcu.be";
  };
}

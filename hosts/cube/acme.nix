{ ulib, ... }: with ulib;

serverSystemConfiguration {
  security.acme = {
    acceptTerms = true;

    defaults = {
      credentialsFile = "/home/cube/.credentials/acme";
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "rgbsphere@gmail.com";
    };

    certs."rgbcu.be".extraDomainNames = [ "*.rgbcu.be" ];
  };
}

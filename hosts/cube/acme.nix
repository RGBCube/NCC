{ self, config, lib, ... }: with lib;

let
  inherit (config.networking) domain;
in systemConfiguration {
  secrets.acmePassword.file = self + /hosts/password.acme.age;

  security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.secrets.acmePassword.path;
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

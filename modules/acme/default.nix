{ config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) mkValue;
in {
  options.acmeGroup = mkValue "nginx";

  config.secrets.acmeEnvironment.file = ./environment.age;

  config.security.acme = {
    acceptTerms = true;

    defaults = {
      environmentFile = config.secrets.acmeEnvironment.path;
      dnsProvider     = "cloudflare";
      dnsResolver     = "1.1.1.1";
      email           = "security@${domain}";
    };

    certs.${domain} = {
      extraDomainNames = [ "*.${domain}" ];
      group            = config.acmeGroup;
    };
  };
}

{ config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) mkValue;
in {
  options.security.acme.users = mkValue [];

  config.secrets.acmeEnvironment.file = ./environment.age;

  config.users.groups.acme.members = config.security.acme.users;

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
      group            = "acme";
    };
  };
}

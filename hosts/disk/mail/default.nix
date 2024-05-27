{ self, config, lib, ... }: with lib;

let
  inherit (config.networking) domain;

  fqdn = "mail1.${domain}";
in systemConfiguration {
  imports = [(self + /hosts/cube/acme)];

  secrets.mailPassword.file = ./password.hash.age;

  services.prometheus.exporters.postfix = enabled {
    listenAddress = "[::]";
  };

  services.restic.backups = genAttrs config.resticHosts (_: {
    paths = [ config.mailserver.dkimKeyDirectory config.mailserver.mailDirectory ];
  });

  mailserver = enabled {
    fqdn = mkDefault fqdn;

    domains           = mkDefault [ domain ];
    certificateScheme = "acme";

    # We use systemd-resolved instead of Knot Resolver.
    localDnsResolver = false;

    hierarchySeparator = "/";
    useFsLayout        = true;

    dkimKeyDirectory = "/var/lib/dkim";
    mailDirectory    = "/var/lib/mail";
    sieveDirectory   = "/var/lib/sieve";

    vmailUserName  = "mail";
    vmailGroupName = "mail";

    dmarcReporting = enabled {
      domain = head config.mailserver.domains;

      organizationName = "Doofemshmirtz Evil Inc.";
    };

    fullTextSearch = enabled {
      indexAttachments = true;
    };

    loginAccounts."contact@${head config.mailserver.domains}" = {
      aliases = [ "@${head config.mailserver.domains}" ];

      hashedPasswordFile = config.secrets.mailPassword.path;
    };
  };
}

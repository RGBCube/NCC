{ self, config, lib, ... }: let
  inherit (lib) const enabled genAttrs head mkDefault;
  inherit (config.networking) domain;
in {
  imports = [(self + /modules/acme)];

  secrets.mailPassword.file = ./password.hash.age;

  services.prometheus.exporters.postfix = enabled {
    listenAddress = "[::]";
  };

  services.restic.backups = genAttrs config.resticHosts <| const {
    paths = [ config.mailserver.dkimKeyDirectory config.mailserver.mailDirectory ];
  };

  acmeGroup = "mail";

  mailserver = enabled {
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

    # The mailserver at <turkiye.gov> malfunctions.
    # dmarcReporting = enabled {
    #   domain = head config.mailserver.domains;

    #   organizationName = "Doofemshmirtz Evil Inc.";
    # };

    fullTextSearch = enabled;

    loginAccounts."contact@${head config.mailserver.domains}" = {
      aliases = [ "@${head config.mailserver.domains}" ];

      hashedPasswordFile = config.secrets.mailPassword.path;
    };
  };
}

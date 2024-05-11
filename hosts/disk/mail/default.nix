{ config, lib, ... }: with lib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";
in systemConfiguration {
  secrets.mailPassword.file = ./password.hash.age;

  services.prometheus.exporters.postfix = enabled {
    listenAddress = "[::]";
  };

  mailserver = enabled {
    inherit fqdn;

    domains           = [ domain ];
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
      inherit domain;

      organizationName = "Doofemshmirtz Evil Inc.";
    };

    fullTextSearch = enabled {
      indexAttachments = true;
    };

    loginAccounts."contact@${domain}" = {
      aliases = [ "@${domain}" ];

      hashedPasswordFile = config.secrets.mailPassword.path;
    };
  };
}

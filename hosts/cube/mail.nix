{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "mail.${domain}";
in serverSystemConfiguration {
  services.prometheus.exporters = {
    dmarc = enabled {
      imap.host         = domain;
      imap.passwordFile = config.age.secrets."cube.mail.password".path;
      imap.username     = "contact@${domain}";

      listenAddress = "::";
      port          = 9020;
    };

    dovecot = enabled {
      port = 9021;
    };

    postfix = enabled {
      port = 9022;
    };

    rspamd  = enabled {
      port = 9023;
    };
  };

  mailserver = enabled {
    inherit fqdn;

    domains = [ domain ];

    certificateScheme = "acme";

    hierarchySeparator = "/";
    useFsLayout        = true;

    dmarcReporting = enabled {
      inherit domain;

      organizationName = "Doofemshmirtz Evil Inc.";
    };

    loginAccounts."contact@${domain}" = {
      aliases = [ "@${domain}" ];

      hashedPasswordFile = config.age.secrets."cube.mail.password.hash".path;
    };
  };
}
